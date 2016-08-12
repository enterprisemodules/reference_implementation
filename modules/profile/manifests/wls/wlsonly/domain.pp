#
# This profile class creates a full running weblogic domain. It's purpose is to be used inside a profile
# defining a WebLogic domain and it's contents
#
# @example usage inside a role class
#   include profile::wls::wlsonly::domain
#
# @param  domain_name [String] the name to use for the domain
# @param  admin_server_arguments [Array] An Array of strings containing the arguments to be passed to the Admin Server
# @param  servers [Hash] A HAsh of servers and Machines
#
class profile::wls::wlsonly::domain(
  String  $domain_name,
  Array   $admin_server_arguments,
  Hash    $servers,
  String  $cluster_name,
)
{
  require profile::wls

  $wls_log_dir       = "${profile::wls::domains_dir}/${domain_name}/servers/logs"
  $server_array      = sort(keys($servers))
  $defaults          = {
    domain_name      => $domain_name,
    nodemanager_port => $profile::wls::nodemanager_port,
    server_arguments => [
      '-XX:PermSize=64m',
      '-Xms768m',
      '-Xmx768m',
    ],
    require          => Wls_adminserver["${domain_name}/AdminServer"],
    before           => Wls_cluster["${domain_name}/${cluster_name}"],
  }

  #
  # This statement creates all machines and WebLogic servers. The content of
  # the $servers variable are read through hiera. Here you can decide if your configuration
  # is a single node system or a multi-node cluster. The nodes and machines them selfs are
  # created after the domain is created.
  #
  create_resources('wls_install::cluster_node', $servers, $defaults)

  #
  # Here you create your domain. The domain is the first thing a WebLogic installation needs. Here
  # you also decide what kind of domain you need. A bare WebLogic
  #
  wls_install::domain{$domain_name:
    domain_name      => $domain_name,
    domain_template  => 'standard',
    bam_enabled      => false,
    b2b_enabled      => false,
    ess_enabled      => false,
    development_mode => false,
  } ->

  #
  # Over here you define the nodemanager. Here you can specify the address
  # the nodemanager is running on and the listen address. When you create multiple domains
  # with multiple nodemanagers, you have to specify different addresses and/or ports.
  #
  wls_install::nodemanager{"nodemanager for ${domain_name}":
    domain_name         => $domain_name,
    nodemanager_address => $profile::wls::nodemanager_address,
    sleep               => 25,
  } ->

  #
  # Before you can manage any WebLogic objects, you'll need to have a running admin server.
  # This code mages sure the admin server is started. Just like with the nodemanager, you'll need
  # to specify unique addresses and ports.
  #
  wls_install::control{"start_adminserver_${domain_name}":
    action      => 'start',
    domain_name => $domain_name,
  } ->

  #
  # wls_setting is used to store the credentials and connect URL of a domain. The Puppet
  # types need this to connect to the admin server and change settings.
  #
  wls_setting{$domain_name:
    user              => $profile::wls::os_user,
    weblogic_user     => $profile::wls::weblogic_user,
    weblogic_password => $profile::wls::weblogic_password,
    connect_url       => "t3://${profile::wls::adminserver_address}:${profile::wls::adminserver_port}",
    weblogic_home_dir => $profile::wls::weblogic_home_dir,
  } ->

  #
  # You can use this wls_server definition to change any settings for your
  # Admin server. because the AdminServer is restarted by wls_adminserver{'soa/AdminServer':}
  # These settings are immediately applied
  #
  wls_server{"${domain_name}/AdminServer":
    ensure                      => 'present',
    arguments                   => $admin_server_arguments,
    listenaddress               => $profile::wls::adminserver_address,
    listenport                  => $profile::wls::adminserver_port,
    machine                     => 'LocalMachine',
    logfilename                 => "${wls_log_dir}/AdminServer/AdminServer_${domain_name}.log",
    log_datasource_filename     => "${wls_log_dir}/AdminServer/datasource.log",
    log_http_filename           => "${wls_log_dir}/AdminServer/access.log",
    log_file_min_size           => '2000',
    log_filecount               => '10',
    log_number_of_files_limited => '1',
    ssllistenport               => '7002',
  } ~>

  #
  # This definition restarts the Admin server. It is a refresh-only, so it is only done
  # when the statement before actually changed something.
  #
  wls_adminserver{"${domain_name}/AdminServer":
    ensure              => running,
    refreshonly         => true,
    server_name         => 'AdminServer',
    domain_name         => $domain_name,
    domain_path         => "${profile::wls::domains_dir}/${domain_name}",
    os_user             => $profile::wls::os_user,
    nodemanager_address => $profile::wls::nodemanager_address,
    nodemanager_port    => $profile::wls::nodemanager_port,
    weblogic_user       => $profile::wls::weblogic_user,
    weblogic_password   => $profile::wls::weblogic_password,
    weblogic_home_dir   => $profile::wls::weblogic_home_dir,
    subscribe           => Wls_install::Domain[$domain_name],
  } ->

  #
  # This is the cluster definition. The server array is extracted from the list of servers
  # and machines,
  #
  wls_cluster{"${domain_name}/${cluster_name}":
    ensure         => 'present',
    messagingmode  => 'unicast',
    migrationbasis => 'consensus',
    servers        => $server_array,
  } ->

  #
  # This class create's a startup script in /etc/init.d.
  #
  wls_install::support::nodemanagerautostart{'wlsony_nodemanager':
    version     => $profile::wls::version,
    wl_home     => $profile::wls::weblogic_home_dir,
    user        => $profile::wls::os_user,
    domain      => $domain_name,
    domain_path => "${profile::wls::domains_dir}/${domain_name}",
  } ->

  #
  # This resource definition pack's the current definition of the domain. This packed domain file
  # can be used by other nodes in the cluster. They fetch it, unpack it and use it to enter the domain.
  # When the node is part of the domain, the packed file loses its value. Any changes in the domain are managed
  # by webLogic.
  #
  wls_install::packdomain{$domain_name:
    domain_name         => $domain_name,
    weblogic_home_dir   => $profile::wls::weblogic_home_dir,
    middleware_home_dir => $profile::wls::middleware_home_dir,
    jdk_home_dir        => $profile::wls::jdk_home_dir,
    wls_domains_dir     => $profile::wls::domains_dir,
    os_user             => $profile::wls::os_user,
    os_group            => $profile::wls::os_group,
    download_dir        => '/data/install',
    log_output          => false,       # Use true when you are debugging
  } ->
  #
  # For now we will put the file in the vagrant directory for sharing. In a real enterprise environment
  # You can use ssh or a shared nfs folder.
  #
  file{"/vagrant/domain_${domain_name}.jar":
    ensure => present,
    source => "/data/install/domain_${domain_name}.jar",
  }
}
