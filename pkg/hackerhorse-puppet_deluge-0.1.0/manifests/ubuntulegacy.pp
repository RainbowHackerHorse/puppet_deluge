# Class: puppet_deluge::ubuntu
# Lightweight deluge module to install a headless deluge server
# This module contains Ubuntu 15.10 and older specific functions.
# Module written by Rainbow <rainbow@hacker.horse>
# Released under the 2-clause BSD license.
# Depends on puppetlabs/apt
#
class puppet_deluge::ubuntulegacy {
  include puppet_deluge::ubuntu
  # Currently, it does not appear that newer versions of Ubuntu differ in 
  # specific syntax required. This module will be built out if that changes.
}