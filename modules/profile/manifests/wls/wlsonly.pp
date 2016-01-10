class profile::wls::wlsonly
{
  contain profile::wls::wlsonly::domain
  contain profile::wls::wlsonly::jms

  Class['profile::wls::wlsonly::domain']
  -> Class['profile::wls::wlsonly::jms']
}