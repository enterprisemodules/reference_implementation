#
# This profile class create's a full running soa domain. It's purpose is to be used inside a profile
# defining a WebLogic domain and it's contents
#
# @example useage inside a role class
#   include profile::wls::server
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
# @param  repository_database_url [String] use following syntax jdbc:oracle:thin:@//hostname:1521/serviename
# @param  rcu_database_url [String] Use following syntax hostname:1521:service
# @param  repository_prefix [String] The prefiex to use when creating RCU database users
# @param  repository_password [String] The password used when creating the RCU repository
# @param  repository_sys_password [String] The sys password of the database. 
#
class profile::wls::server(
  String  $domain_name,
  String  $nodemanager_address,
  Integer $nodemanager_port,
  String  $adminserver_address,
  Integer $adminserver_port,
  Array   $admin_server_arguments,
  String  $domains_dir,
  String  $apps_dir,
  String  $os_user,
  String  $weblogic_user,
  String  $weblogic_password,
  String  $weblogic_home_dir,
  Integer $version,
)
{
  wls_install::copydomain{$domain_name:
    version                                => $version,
    weblogic_home_dir                      => $weblogic_home_dir,
    middleware_home_dir                    => $weblogic_home_dir,
    jdk_home_dir                           => $jdk_home_dir,
    wls_domains_dir                        => $domains_dir,
    wls_apps_dir                           => $apps_dir,
    domain_name                            => $domain_name,
    os_user                                => $os_user,
    os_group                               => $os_group,
    download_dir                           => "/data/install",
    log_dir                                => "/var/log/weblogic",
    log_output                             => true,
    use_ssh                                => false,
    domain_pack_dir                        => '/vagrant',
    adminserver_address                    => $adminserver_address,
    adminserver_port                       => $adminserver_port,
    weblogic_user                          => $weblogic_user,
    weblogic_password                      => $weblogic_password,
  }

}