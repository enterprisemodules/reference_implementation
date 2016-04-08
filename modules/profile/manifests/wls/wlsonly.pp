class profile::wls::wlsonly
{
  contain profile::wls::wlsonly::domain
  #
  # For every datasource create a class. This helps in easy management of parameters.
  #
  contain profile::wls::wlsonly::datasources::ds0
  contain profile::wls::wlsonly::jms

  Class['profile::wls::wlsonly::domain']
  -> Class['profile::wls::wlsonly::datasources::ds0']
  -> Class['profile::wls::wlsonly::jms']
}