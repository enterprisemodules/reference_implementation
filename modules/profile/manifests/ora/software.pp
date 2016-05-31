class profile::ora::software(
  String  $version,
  String  $file_name,
  String  $type,
  String  $oracle_home,
  String  $oracle_base,
)
{
  ora_install::installdb{$file_name:
    version                   => $version,
    file                      => $file_name,
    database_type             => $type,
    oracle_base               => $oracle_base,
    oracle_home               => $oracle_home,
    puppet_download_mnt_point => '/vagrant/software',
    remote_file               => false,
  }

}