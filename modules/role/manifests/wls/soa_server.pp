class role::wls::soa_server()
{
  contain profile::base::config
  contain profile::base::hosts
  contain profile::wls::os
  contain profile::java
  contain profile::wls::software
  contain profile::wls::fmw_software
  contain profile::wls::server

  Class['profile::base::hosts'] ->
  Class['profile::wls::os'] ->
  Class['profile::java'] ->
  Class['profile::wls::software'] ->
  Class['profile::wls::fmw_software'] ->
  Class['profile::wls::server']
}
