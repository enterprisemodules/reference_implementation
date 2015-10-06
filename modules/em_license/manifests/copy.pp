# Class: em_license::copy_licenses
#
# This module copies all of your licenses from a master over to an agent system. The enterprise modules 
# need those on the agents. 
#
class em_license::copy {

  file{'/etc/puppetlabs/puppet/em_license':
    ensure => 'directory'
  }
  #
  # Enter all your licenses over here
  #
  # file{'/etc/puppetlabs/puppet/em_license/1-my_organisation.entitlements':
  #   ensure => 'present',
  #   source => 'puppet:///modules/em_license/1-my_organisation.entitlements',
  # }
}
