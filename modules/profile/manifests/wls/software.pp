class profile::wls::software(
  String  $middleware_home_dir,
  String  $oracle_base_home_dir,
  String  $filename,
  Boolean $fmw_infra,
)
{

  class{'wls_install::software':
    version              => 1213,
    filename             => $filename,
    fmw_infra            => $fmw_infra,
    middleware_home_dir  => $middleware_home_dir,
    oracle_base_home_dir => $oracle_base_home_dir,
    jdk_home_dir         => '/usr/java/jdk1.7.0_79',
    os_user              => 'weblogic',
    os_group             => 'weblogic',
    download_dir         => '/data/install',
    source               => '/vagrant/software',
    remote_file          => false,
  }
  contain wls_install::software
}

