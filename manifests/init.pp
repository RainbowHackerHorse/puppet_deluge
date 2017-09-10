# Class: puppet_freebsd_deluge
# Lightweight deluge module to install a headless deluge server on FreeBSD
# Module written by Rainbow <rainbow@hacker.horse>
# Released under the 2-clause BSD license.

class puppet_freebsd_deluge {
  package { 'deluge-cli':
    ensure  => latest,
    require => User['deluge'],
  }
  package { 'deluge-web':
    ensure  => absent,
    require => User['deluge'],
  }
  package { 'py27-service_identity':
    ensure => installed,
  }
  file { '/usr/local/etc/rc.d/deluged':
    owner   => 'root',
    group   => 'wheel',
    mode    => '0755',
    source  => 'puppet:///modules/freebsd_deluge_light/deluged_init.sh',
    require => User['deluge'],
  }
  user { 'deluge':
    ensure  => present,
    groups  => 'deluge',
    comment => 'deluge user',
    home    => '/home/deluge',
    shell   => '/bin/sh',
    require => Group['deluge'],
  }

  group { 'deluge':
    ensure => present,
  }

  file { '/home/deluge':
    ensure  => directory,
    owner   => 'deluge',
    group   => 'deluge',
    mode    => '0744',
    require => User['deluge']
  }
  exec { 'delfirstrun':
    command => '/usr/local/bin/deluged',
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    user    => 'deluge',
    require => User['deluge'],
    before  => File['/home/deluge/.config/deluge/auth'],
    unless  => 'test -f /home/deluge/.config/',
  }

  file { '/home/deluge/.config/deluge/auth':
    owner   => 'deluge',
    group   => 'deluge',
    mode    => '0600',
    source  => 'puppet:///modules/freebsd_deluge_light/auth',
    require => File['/home/deluge'],
  }
  file { '/home/deluge/.config/deluge/core.conf':
    owner   => 'deluge',
    group   => 'deluge',
    mode    => '0600',
    source  => 'puppet:///modules/freebsd_deluge_light/core.conf',
    require => File['/home/deluge'],
  }
  exec { 'addtorc':
    command => 'echo deluged_enable=\"YES\" >> /etc/rc.conf && touch /usr/local/etc/deluged_enable.txt',
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    unless  => 'test -f /usr/local/etc/deluged_enable.txt',
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