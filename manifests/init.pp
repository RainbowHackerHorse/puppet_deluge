# Class: puppet_freebsd_deluge
# Lightweight deluge module to install a headless deluge server on FreeBSD
# Module written by Rainbow <rainbow@hacker.horse>
# Released under the 2-clause BSD license.

class puppet_deluge {
  if $facts['os']['family'] == 'FreeBSD' {
    include puppet_deluge::freebsd
  }
  elsif $facts['os']['family'] == 'Linux' {
    if $facts['os']['distro'] == 'Ubuntu' {
      include puppet_deluge::ubuntu
    }
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
}