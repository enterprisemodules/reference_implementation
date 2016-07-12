class profile::wls::software(
  String  $middleware_home_dir,
  String  $oracle_base_home_dir,
  String  $filename,
  String  $os_user,
  String  $os_group,
  String  $software_source,
  Integer $version,
  Boolean $fmw_infra,
)
{

  class{'wls_install::software':
    version              => $version,
    filename             => $filename,
    fmw_infra            => $fmw_infra,
    middleware_home_dir  => $middleware_home_dir,
    oracle_base_home_dir => $oracle_base_home_dir,
    jdk_home_dir         => '/usr/java/jdk1.8.0_74',
    os_user              => $os_user,
    os_group             => $os_group,
    download_dir         => '/data/install',
    source               => $software_source,
    remote_file          => false,
  }
  contain wls_install::software
}

