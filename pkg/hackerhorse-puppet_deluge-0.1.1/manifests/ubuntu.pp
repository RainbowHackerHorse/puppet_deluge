# Class: puppet_deluge::ubuntu
# Lightweight deluge module to install a headless deluge server
# This module contains Ubuntu 16.04+ specific functions.
# Module written by Rainbow <rainbow@hacker.horse>
# Released under the 2-clause BSD license.
# Depends on puppetlabs/apt
#
class puppet_deluge::ubuntu {
  include apt
  package { 'python-software-properties':
    ensure => installed,
  }
  package { 'deluge-console':
    ensure  => latest,
    require => [User['deluge'], Apt::Ppa['ppa:deluge-team/ppa']],
  }
  package { 'deluged':
    ensure  => latest,
    require => User['deluge'],
  }
  package { 'deluge-web':
    ensure  => absent,
    require => User['deluge'],
  }
  service { 'deluge':
    ensure  => running,
    enable  => true,
    require => User['deluge'],
  }
  apt::ppa { 'ppa:deluge-team/ppa':
    require => Package['python-software-properties'],
  }
  file { 'zroot/torrents':
    ensure  => directory,
    owner   => deluge,
    mode    => '0644',
    require => User['deluge'],
  }
  file { 'zroot/torrents/downloading':
    ensure  => directory,
    owner   => deluge,
    mode    => '0644',
    require => User['deluge'],
  }
  file { 'zroot/torrents/files':
    ensure  => directory,
    owner   => deluge,
    mode    => '0644',
    require => User['deluge'],
  }
  file { 'zroot/torrents/completed':
    ensure  => directory,
    owner   => deluge,
    mode    => '0644',
    require => User['deluge'],
  }
}