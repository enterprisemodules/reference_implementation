class role::wls::server()
{
  contain profile::base::config
  contain profile::base::hosts
  contain profile::wls::os
  contain profile::java
  contain profile::wls::software
  contain profile::wls::server

  Class['profile::base::hosts']
  -> Class['profile::wls::os']
  -> Class['profile::java']
  -> Class['profile::wls::software']
  -> Class['profile::wls::server']
}
