class profile::ora::demodb::database()
{
  require profile::ora
  #
  # All standard values fetched in data function
  #
  ora_database{$profile::ora::dbname:
    ensure                  => present,
    oracle_base             => $profile::ora::base,
    oracle_home             => $profile::ora::home,
    control_file            => 'reuse',
    system_password         => $profile::ora::system_password,
    sys_password            => $profile::ora::sys_password,
    character_set           => 'AL32UTF8',
    national_character_set  => 'AL16UTF16',
    extent_management       => 'local',
    logfile_groups => [
        {file_name => 'demo1.log', size => '512M', reuse => true},
        {file_name => 'demo2.log', size => '512M', reuse => true},
      ],
    default_tablespace => {
      name      => 'USERS',
      datafile  => {
        file_name  => 'users.dbs',
        size       => '50M',
        reuse      =>  true,
        autoextend => {next => '10M', maxsize => 'unlimited'}
      },
      extent_management => {
        'type'        => 'local',
        autoallocate  => true,
      }
    },
    datafiles       => [
      {file_name   => 'demo1.dbs', size => '100M', reuse => true, autoextend => {next => '100M', maxsize => 'unlimited'}},
    ],
    default_temporary_tablespace => {
      name      => 'TEMP',
      'type'    => 'bigfile',
      tempfile  => {
        file_name  => 'tmp.dbs',
        size       => '100M',
        reuse      =>  true,
        autoextend => {
          next    => '50M',
          maxsize => 'unlimited',
        }
      },
    },
    undo_tablespace   => {
      name      => 'UNDOTBS',
      'type'    => 'bigfile',
      datafile  => {
        file_name  => 'undo.dbs',
        size       => '100M',
        reuse      =>  true,
        autoextend => {next => '50M', maxsize => 'unlimited'}      }
    },
    timezone       => '+01:00',
    sysaux_datafiles => [
      {file_name   => 'sysaux1.dbs', size => '100M', reuse => true, autoextend => {next => '50M', maxsize => 'unlimited'}},
    ],
  } ->

  ora_install::dbactions{ "start_${profile::ora::dbname}":
    oracle_home => $profile::ora::home,
    db_name     => $profile::ora::dbname,
  } ->

  ora_install::autostartdatabase{ 'autostart oracle':
    oracle_home => $profile::ora::home,
    db_name     => $profile::ora::dbname,
  } ->

  file{'/tmp': ensure => 'directory'} ->

  ora_install::net{ 'config net8':
    oracle_home  => $profile::ora::home,
    version      => '12.1',        # Different version then the oracle version
    download_dir => '/tmp',
  } ->

  ora_install::listener{'start listener':
    oracle_base  => $profile::ora::base,
    oracle_home  => $profile::ora::home,
    action       => 'start',
  }

  ora_service{"demo.example.com@${profile::ora::dbname}":
    ensure => present,
  } ->
  ora_service{"demo@${profile::ora::dbname}":
    ensure => present,
  }

}