# Class: puppet_deluge::zfs
# Lightweight deluge module to install a headless deluge server
# This module contains ZFS specific functions.
# Module written by Rainbow <rainbow@hacker.horse>
# Released under the 2-clause BSD license.
# Depends on puppetlabs/apt
#
class puppet_deluge::zfs {
  zfs { 'zroot/torrents':
    ensure       => present,
    atime        => 'on',
    canmount     => 'on',
    checksum     => 'on',
    compression  => 'on',
    copies       => '1',
    dedup        => 'off',
    exec         => 'on',
    mountpoint   => '/torrents',
    primarycache => 'metadata',
    quota        => 'none',
    readonly     => 'off',
  }
  file { '/torrents':
    owner   => 'deluge',
    mode    => '0644',
    require => [User['deluge'], Zfs['zroot/torrents']],
  }

  zfs { 'zroot/torrents/downloading':
    ensure       => present,
    atime        => 'on',
    canmount     => 'on',
    checksum     => 'on',
    compression  => 'on',
    copies       => '1',
    dedup        => 'off',
    exec         => 'on',
    mountpoint   => '/torrents/downloading',
    primarycache => 'metadata',
    quota        => 'none',
    readonly     => 'off',
  }
  file { '/torrents/downloading':
    owner   => 'deluge',
    mode    => '0644',
    require => [User['deluge'], Zfs['zroot/torrents/downloading']],
  }

  zfs { 'zroot/torrents/files':
    ensure       => present,
    atime        => 'on',
    canmount     => 'on',
    checksum     => 'on',
    compression  => 'on',
    copies       => '1',
    dedup        => 'off',
    exec         => 'on',
    mountpoint   => '/torrents/files',
    primarycache => 'metadata',
    quota        => 'none',
    readonly     => 'off',
  }
  file { '/torrents/files':
    owner   => 'deluge',
    mode    => '0644',
    require => [User['deluge'], Zfs['zroot/torrents/files']],
  }

  zfs { 'zroot/torrents/completed':
    ensure       => present,
    atime        => 'on',
    canmount     => 'on',
    checksum     => 'on',
    compression  => 'on',
    copies       => '1',
    dedup        => 'off',
    exec         => 'on',
    mountpoint   => '/torrents/completed',
    primarycache => 'metadata',
    quota        => 'none',
    readonly     => 'off',
  }
  file { '/torrents/completed':
    owner   => 'deluge',
    mode    => '0644',
    require => [User['deluge'], Zfs['zroot/torrents/completed']],
  }
}
