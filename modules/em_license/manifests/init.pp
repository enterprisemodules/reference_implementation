# Class: em_license::copy_licenses
#
# This module makes sure all of your licenses for enterprise modules are available on the system.
#
#
class em_license{

  class{'::em_license::copy':
    stage => 'setup',
  }
}
