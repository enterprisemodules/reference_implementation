class profile::ora::asmdb::database(
  String  $dbname,
  String  $dbdomain,
  String  $oracle_home,
  String  $oracle_base,
  String  $system_password,
  String  $sys_password,
){

  ora_asm_diskgroup{ 'RECO@+ASM':
    ensure          => 'present',
    au_size         => '1',
    compat_asm      => '11.2.0.0.0',
    compat_rdbms    => '10.1.0.0.0',
    diskgroup_state => 'MOUNTED',
    disks           => {'RECO_0000' => [{'diskname' => 'RECO_0000', 'path' => '/nfs_client/asm_sda_nfs_b3'}], 'RECO_0001' => [{'diskname' => 'RECO_0001', 'path' => '/nfs_client/asm_sda_nfs_b4'}]},
    redundancy_type => 'EXTERNAL',
  } ->


  ora_install::database{ $dbname:
    oracle_base               => $oracle_base,
    oracle_home               => $oracle_home,
    download_dir              => '/vagrant/software',
    action                    => 'create',
    db_name                   => $dbname,
    db_domain                 => $dbdomain,
    sys_password              => $sys_password,
    system_password           => $system_password,
    template                  => 'dbtemplate_12.1_asm',
    character_set             => 'AL32UTF8',
    nationalcharacter_set     => 'UTF8',
    sample_schema             => 'false',
    memory_percentage         => 40,
    memory_total              => 2880,
    database_type             => 'MULTIPURPOSE',
    em_configuration          => 'NONE',
    storage_type              => 'ASM',
    asm_snmp_password         => 'Welcome01',
    asm_diskgroup             => 'DATA',
    recovery_diskgroup        => 'RECO',
    recovery_area_destination => 'RECO',
    puppet_download_mnt_point => 'ora_install/',
  } ->

  ora_install::dbactions{ "start_${dbname}":
    oracle_home => $oracle_home,
    db_name     => $dbname,
  } ->

  ora_install::autostartdatabase{ 'autostart oracle':
    oracle_home => $oracle_home,
    db_name     => $dbname,
  } 

  file{'/tmp': ensure => 'directory'} ->

  ora_install::net{ 'config net8':
    oracle_home  => $oracle_home,
    version      => '12.1',        # Different version then the oracle version
    download_dir => '/tmp',
  } ->

  ora_install::listener{'start listener':
    oracle_base  => $oracle_base,
    oracle_home  => $oracle_home,
    action       => 'start',
  }

  ora_service{"asmdb.example.com@${dbname}":
    ensure => present,
  } ->
  ora_service{"asmdb@${dbname}":
    ensure => present,
  }

}