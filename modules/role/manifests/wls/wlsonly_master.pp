class role::wls::wlsonly_master()
{
  contain profile::base
  contain profile::wls::os
  contain profile::java
  contain profile::wls::software
  contain profile::wls::wlsonly

  Class['profile::base'] ->
  Class['profile::wls::os'] ->
  Class['profile::java'] ->
  Class['profile::wls::software'] ->
  Class['profile::wls::wlsonly']
}