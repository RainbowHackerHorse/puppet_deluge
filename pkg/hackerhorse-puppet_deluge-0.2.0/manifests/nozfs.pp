# Class: puppet_deluge::nozfs
# Lightweight deluge module to install a headless deluge server
# This module contains legacy directory specific functions.
# Module written by Rainbow <rainbow@hacker.horse>
# Released under the 2-clause BSD license.
# Depends on puppetlabs/apt
#
class puppet_deluge::nozfs {
    file { '/torrents':
    ensure  => directory,
    owner   => deluge,
    mode    => '0644',
    require => User['deluge'],
  }
  file { '/torrents/downloading':
    ensure  => directory,
    owner   => deluge,
    mode    => '0644',
    require => [User['deluge'], File['/torrents']],
  }
  file { '/torrents/files':
    ensure  => directory,
    owner   => deluge,
    mode    => '0644',
    require => [User['deluge'], File['/torrents']],
  }
  file { '/torrents/completed':
    ensure  => directory,
    owner   => deluge,
    mode    => '0644',
    require => [User['deluge'], File['/torrents']],
  }
}