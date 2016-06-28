class profile::grid::nfs {

  $nfs_files = ['/home/nfs_server_data/asm_sda_nfs_b1','/home/nfs_server_data/asm_sda_nfs_b2','/home/nfs_server_data/asm_sda_nfs_b3','/home/nfs_server_data/asm_sda_nfs_b4']

  file { '/home/nfs_server_data':
    ensure  => directory,
    recurse => false,
    replace => false,
    mode    => '0775',
    owner   => 'grid',
    group   => 'asmadmin',
  } ->

  exec { '/bin/dd if=/dev/zero of=/home/nfs_server_data/asm_sda_nfs_b1 bs=1M count=7520':
    user      => 'grid',
    group     => 'asmadmin',
    logoutput => true,
    unless    => '/usr/bin/test -f /home/nfs_server_data/asm_sda_nfs_b1',
  } ->

  exec { '/bin/dd if=/dev/zero of=/home/nfs_server_data/asm_sda_nfs_b2 bs=1M count=7520':
    user      => 'grid',
    group     => 'asmadmin',
    logoutput => true,
    unless    => '/usr/bin/test -f /home/nfs_server_data/asm_sda_nfs_b2',
  } ->

  exec { '/bin/dd if=/dev/zero of=/home/nfs_server_data/asm_sda_nfs_b3 bs=1M count=7520':
    user      => 'grid',
    group     => 'asmadmin',
    logoutput => true,
    unless    => '/usr/bin/test -f /home/nfs_server_data/asm_sda_nfs_b3',
  } ->

  exec { '/bin/dd if=/dev/zero of=/home/nfs_server_data/asm_sda_nfs_b4 bs=1M count=7520':
    user      => 'grid',
    group     => 'asmadmin',
    logoutput => true,
    unless    => '/usr/bin/test -f /home/nfs_server_data/asm_sda_nfs_b4',
  } ->

  file { $nfs_files:
    ensure  => present,
    owner   => 'grid',
    group   => 'asmadmin',
    mode    => '0664',
  } ->

  class { '::nfs':
    server_enabled => true,
    client_enabled => true,
  } ->

  nfs::server::export{ '/home/nfs_server_data':
    ensure      => 'mounted',
    options_nfs => 'rw sync no_wdelay insecure_locks no_root_squash',
    clients     => '10.10.10.0/24(rw,insecure,async,no_root_squash) localhost(rw)',
  } ->


  file { '/nfs_client':
    ensure  => directory,
    recurse => false,
    replace => false,
    mode    => '0775',
    owner   => 'grid',
    group   => 'asmadmin',
  } ->


  nfs::client::mount { '/nfs_client':
    server        => 'asmdb',
    share         => '/home/nfs_server_data',
    remounts      => true,
    atboot        => true,
    options_nfs   => 'rw,bg,hard,nointr,tcp,vers=3,timeo=600,rsize=32768,wsize=32768',
  } 

}
