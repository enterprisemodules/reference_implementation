class profile::ora::software(
  $version,
  $file_name,
  $type,
)
{
  include profile
  include profile::ora

  ora_install::installdb{$file_name:
    version                   => $version,
    file                      => $file_name,
    database_type             => $type,
    oracle_base               => $profile::ora::base,
    oracle_home               => $profile::ora::home,
    puppet_download_mnt_point => $profile::source_dir,
    remote_file               => false,
  }

}
