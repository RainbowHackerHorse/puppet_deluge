# Class: puppet_deluge::freebsd
# Lightweight deluge module to install a headless deluge server
# This module contains FreeBSD specific functions
# Module written by Rainbow <rainbow@hacker.horse>
# Released under the 2-clause BSD license.
# Depends on snonux/zfs
#
class puppet_deluge::freebsd {
    package { 'deluge-cli':
    ensure  => latest,
    require => User['deluge'],
  }
  package { 'deluge-web':
    ensure  => absent,
    require => User['deluge'],
  }
  package { 'py27-service_identity':
    ensure => latest,
  }
  file { '/usr/local/etc/rc.d/deluged':
    owner   => 'root',
    group   => 'wheel',
    mode    => '0755',
    source  => 'puppet:///modules/freebsd_deluge_light/deluged_init.sh',
    require => User['deluge'],
  }
  exec { 'delfirstrun':
    command => '/usr/local/bin/deluged',
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    user    => 'deluge',
    require => User['deluge'],
    before  => File['/home/deluge/.config/deluge/auth'],
    unless  => 'test -f /home/deluge/.config/',
  }
  service { 'deluge':
      ensure  => running,
      enable  => true,
      require => File['/usr/local/etc/rc.d/deluged'],
  }
  zfs::create { 'zroot/torrents':
    ensure     => present,
    filesystem => '/torrents',
  }
  zfs::create { 'zroot/torrents/downloading':
    ensure     => present,
    filesystem => '/torrents/downloading',
    require    => Zfs::Create['zroot/torrents'],
  }
  zfs::create { 'zroot/torrents/files':
    ensure     => present,
    filesystem => '/torrents/files',
    require    => Zfs::Create['zroot/torrents'],
  }
  zfs::create { 'zroot/torrents/completed':
    ensure     => present,
    filesystem => '/torrents/completed',
    require    => Zfs::Create['zroot/torrents'],
  }
  exec { 'zfsperms':
    command => 'chown -R deluge:deluge /torrents',
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    require => [Zfs::Create['zroot/torrents'], Zfs::Create['zroot/torrents/downloading'], Zfs::Create['zroot/torrents/files'], Zfs::Create['zroot/torrents/completed']],
  }
}