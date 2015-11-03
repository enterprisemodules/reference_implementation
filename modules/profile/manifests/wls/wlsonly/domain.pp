#
# This profile class create's a full running weblogic domain. It's purpose is to be used inside a profile
# defining a WebLogic domain and it's contents
#
# @example useage inside a role class
#   include profile::wls::wlsonly::domain
#
# @param  domain_name [String] the name to use for the domain
# @param  nodemanager_address [String] a valid ipadress or hostname where the nodemanager will be binded to
# @param  nodemanager_port [Integer] a valid port number on which the nodemanager will run
# @param  adminserver_address [String] a valid ipaddress or hostname where the adminserver will be binded to
# @param  adminserver_port [Integer] a valid port number on which the admin server will run
# @param  admin_server_arguments [Array] An Array of strings containing the arguments to be passed to the Admin Server
# @param  domains_dir [String] The directory containing all domains
# @param  apps_dir [String] The directory containing all applications
# @param  os_user [String] The os user used to create and runn all WebLogic processes in
# @param  weblogic_user [String] The name of the main WebLogic user. Used for logging into the admin server
# @param  weblogic_password [String] The password used when logging into the admin server
# @param  weblogic_home_dir [String] The directory containing all weblogic software
# @param  version [Integer] The WebLogic version used
# @param  servers [Hash] A HAsh of servers and Machines
#
class profile::wls::wlsonly::domain(
  String  $domain_name,
  String  $nodemanager_address,
  Integer  $nodemanager_port,
  String  $adminserver_address,
  Integer $adminserver_port,
  String  $domains_dir,
  String  $apps_dir,
  String  $os_user,
  String  $weblogic_user,
  String  $weblogic_password,
  String  $weblogic_home_dir,
  Integer $version,
  Array   $admin_server_arguments,
  Hash    $servers,
)
{

  $wls_log_dir = "${domains_dir}/${domain_name}/servers/logs"
  $server_array      = sort(keys($servers))
  $defaults          = {
    domain_name      => $domain_name,
    nodemanager_port => $nodemanager_port,
    server_arguments => [
      '-XX:PermSize=64m',
      '-XX:MaxPermSize=512m',
      '-Xms768m',
      '-Xmx768m',
    ],
    require          => Wls_adminserver['wlsonly/AdminServer'],
    before           => Wls_cluster['wlsonly/WlsOnlyCluster'],
  }

  #
  # This statement creates all machines and WebLogic servers. The content of
  # the $servers variable are read through hiera. Here you ca decide if your configuration
  # is a single node system or a multi-node cluster. The nodes and machines them selfs are 
  # created after the domain is created.
  #
  create_resources('wls_install::cluster_node', $servers, $defaults)

  #
  # Here you create your domain. The domain is the first thing a WebLogic installation needs. Here
  # you also decide what kind of domain you need. A bare WebLogic 
  #
  wls_install::domain{'wlsonly':
    domain_name                          => $domain_name,
    version                              => $version,
    wls_domains_dir                      => $domains_dir,
    wls_apps_dir                         => $apps_dir,
    domain_template                      => 'standard',
    bam_enabled                          => false,
    b2b_enabled                          => false,
    ess_enabled                          => false,
    development_mode                     => false,
    adminserver_listen_on_all_interfaces => false,
    adminserver_address                  => $adminserver_address,
    adminserver_port                     => $adminserver_port,
    nodemanager_address                  => $nodemanager_address,
    nodemanager_port                     => $nodemanager_port,
  } ->

  #
  # Over here you define the nodemanager. Here you can specify the address
  # the nodemanager is running on and the listen address. When you create multiple domains
  # with multiple nodemanagers, you have to specify different addresses and/or ports.
  #
  wls_install::nodemanager{"nodemanager for ${domain_name}":
    domain_name         => $domain_name,
    version             => $version,
    nodemanager_address => $nodemanager_address,
    nodemanager_port    => $nodemanager_port,
    log_dir             => "${domains_dir}/${domain_name}/nodemanager",
    sleep               => 25,
  } ->

  #
  # Before you can manage any WebLogic objects, you'll need to have a running admin server.
  # This code mages sure the admin server is started. Just like with the nodemanager, you'll need
  # to specify unique addresses and ports.
  #
  wls_install::control{"start_adminserver_${domain_name}":
    action              => 'start',
    domain_name         => $domain_name,
    adminserver_address => $adminserver_address,
    adminserver_port    => $adminserver_port,
    nodemanager_port    => $nodemanager_port,
    weblogic_user       => $weblogic_user,
    weblogic_password   => $weblogic_password,
    os_user             => $os_user,
  } ->

  #
  # wls_setting is used to store the credentials and connect URL of a domain. The Puppet
  # types need this to connect to the admin server and change settings.
  #
  wls_setting{'wlsonly':
    user              => $os_user,
    weblogic_user     => $weblogic_user,
    weblogic_password => $weblogic_password,
    connect_url       => "t3://${adminserver_address}:${adminserver_port}",
    weblogic_home_dir => $weblogic_home_dir,
  } ->

  #
  # You can use this wls_server definition to change any settings for your
  # Admin server. because the AdminServer is restarted by wls_adminserver{'soa/AdminServer':}
  # These settings are immediately applied
  #
  wls_server{"wlsonly/AdminServer":
    ensure                        => 'present',
    arguments                     => $admin_server_arguments,
    listenaddress                 => $adminserver_addres,
    listenport                    => $adminserver_port,
    machine                       => 'LocalMachine',
    logfilename                   => "${wls_log_dir}/AdminServer/AdminServer_${domain_name}.log",
    log_datasource_filename       => "${wls_log_dir}/AdminServer/datasource.log",
    log_http_filename             => "${wls_log_dir}/AdminServer/access.log",
    log_file_min_size             => '2000',
    log_filecount                 => '10',
    log_number_of_files_limited   => '1',
    ssllistenport                 => '7002',
  } ~>

  #
  # This definition restarts the Admin server. It is a refresh-only, so it is only done 
  # when the statement before actually changed something.  
  #
  wls_adminserver{'wlsonly/AdminServer':
    ensure              => running,
    refreshonly         => true,
    server_name         => 'AdminServer',
    domain_name         => $domain_name,
    domain_path         => "${domains_dir}/${domain_name}",
    os_user             => $os_user,
    nodemanager_address => $nodemanager_address,
    nodemanager_port    => $nodemanager_port,
    weblogic_user       => $weblogic_user,
    weblogic_password   => $weblogic_password,
    weblogic_home_dir   => $weblogic_home_dir,
    subscribe           => Wls_install::Domain['wlsonly'],
  } ->

  #
  # This is the cluster definition. The server array is extracted from the list of servers 
  # and machines,
  #
  wls_cluster{'wlsonly/WlsOnlyCluster':
    ensure         => 'present',
    messagingmode  => 'unicast',
    migrationbasis => 'consensus',
    servers        => $server_array,
  } ->

  #
  # This class create's a startup script in /etc/init.d.
  #
  wls_install::support::nodemanagerautostart{'wlsony_nodemanager':
    version                   => $version,
    wl_home                   => $weblogic_home_dir,
    user                      => $os_user,
    domain                    => $domain_name,
    domain_path               => "${domains_dir}/${domain_name}",
  }
}
