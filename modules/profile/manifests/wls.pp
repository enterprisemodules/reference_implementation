class profile::wls(
  $os_user              = lookup('wls_os_user'),
  $os_group             = lookup('wls_os_group'),
  $weblogic_home_dir    = lookup('wls_weblogic_home_dir'),
  $middleware_home_dir  = lookup('wls_middleware_home_dir'),
  $oracle_base_home_dir = lookup('wls_oracle_base_home_dir'),
  $jdk_home_dir         = lookup('wls_jdk_home_dir'),
  $version              = lookup('wls_version'),
  $domains_dir          = lookup('wls_domains_dir'),
  $weblogic_user        = lookup('wls_weblogic_user'),
  $weblogic_password    = lookup('domain_wls_password'),
  $adminserver_address  = lookup('domain_adminserver_address'),
  $adminserver_port     = lookup('domain_adminserver_port'),
  $nodemanager_port     = lookup('domain_nodemanager_port'),
  $nodemanager_address  = lookup('domain_nodemanager_address'),
)
{}

