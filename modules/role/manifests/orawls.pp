#
# This role includes both a Oracle database and WebLogic server
#
class role::orawls()
{
  contain profile::base
  contain profile::shared::os

  contain profile::ora::software
  contain profile::ora::patches
  contain profile::ora::demodb

  contain profile::java
  contain profile::wls::software
  contain profile::wls::wlsonly

  Class['profile::base']
  -> Class['profile::shared::os']
  -> Class['profile::ora::software']
  -> Class['profile::ora::patches']
  -> Class['profile::ora::demodb']

  Class['profile::shared::os']
  -> Class['profile::java']
  -> Class['profile::wls::software']
  -> Class['profile::wls::wlsonly']

}
