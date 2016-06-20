class profile::wls::software(
  String  $filename,
  Boolean $fmw_infra,
)
{
  require profile
  require profile::wls

  class{'wls_install::software':
    version              => $profile::wls::version,
    filename             => $filename,
    oracle_base_home_dir => $profile::wls::oracle_base_home_dir,
    middleware_home_dir  => $profile::wls::middleware_home_dir,
    fmw_infra            => $fmw_infra,
    jdk_home_dir         => $profile::wls::jdk_home_dir,
    os_user              => $profile::wls::os_user,
    os_group             => $profile::wls::os_group,
    download_dir         => $profile::download_dir,
    source               => $profile::source_dir,
    remote_file          => false,
  }
  contain wls_install::software
}
