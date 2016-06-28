class profile::grid::software(
  String  $version,
  String  $file_name,
  String  $grid_home,
  String  $grid_base,
)
{
    ora_install::installasm{ 'db_linux-x64':
      version                   => $version,
      file                      => $file_name,
      grid_type                 => 'HA_CONFIG',
      grid_base                 => $grid_base,
      grid_home                 => $grid_home,
      user                      => 'grid',
      asm_diskgroup             => 'DATA',
      disk_discovery_string     => '/nfs_client/asm*',
      disks                     => '/nfs_client/asm_sda_nfs_b1,/nfs_client/asm_sda_nfs_b2',
      disk_redundancy           => 'EXTERNAL',
      puppet_download_mnt_point => '/vagrant/software',
      remote_file               => false,
    } 

}