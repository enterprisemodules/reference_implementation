#
# This profile class creates the full JMS setup for the wlsonly domain. 
# It creates the required JMS servers, the JMS modules and then creates some queue's and topics.
#
# @example usage inside a role class
#   include profile::wls::wlsonly::jms
#
# @param  servers [Hash] A HAsh of servers and Machines
# @param  domain_name [String] the name to use for the domain
# @param  cluster_name [String] the name to use for the WebLogic cluster
#
class profile::wls::wlsonly::jms(
  Hash    $servers,
  String  $domain_name,
  String  $cluster_name,
)
{

  $server_array = $servers.keys
  $server_array.each | $index, $server | {
    #
    # Create a JMS server for every managed server and target the JMS server to the managed server.
    # because the set of managed servers, is a variable, this code works if you have 1 or more servers.
    #
    wls_jmsserver { "${domain_name}/jmsServer${index}":
      ensure                      => 'present',
      allows_persistent_downgrade => '0',
      bytes_maximum               => '-1',
      target                      => [$server],
      targettype                  => ['Server'],
    }
  }
  #
  # Every JMS resource needs a JMS module So we create one here and target it at the 
  # cluster
  #
  wls_jms_module { "${domain_name}/jmsClusterModule":
    ensure     => 'present',
    target     => [$cluster_name],
    targettype => ['Cluster'],
  }

  #
  # For JMS targeting, we need the names of all JMS server in an Array. Also we need an array
  # of target_types. We build this array from iterating over the servers
  #
  $jms_targets      = $server_array.map | $index, $name | { "jmsServer${index}" }
  $jms_target_types = $server_array.map | $name | { 'JMSServer'}

  wls_jms_subdeployment { "${domain_name}/jmsClusterModule:jmsServers":
    ensure     => 'present',
    target     => $jms_targets,
    targettype => $jms_target_types,
  }

  wls_jms_subdeployment { "${domain_name}/jmsClusterModule:wlsServers":
    ensure     => 'present',
    target     => [$cluster_name],
    targettype => ['Cluster'],
  }

  #
  # To make the actual connection factories so concise as possible,
  # we extract all settings that are common for all CF's to a defaults block.
  #
  Wls_jms_connection_factory {
    ensure                    => 'present',
    attachjmsxuserid          => '0',
    clientidpolicy            => 'Restricted',
    defaultdeliverymode       => 'Persistent',
    jndiname                  => 'jms/cf',
    loadbalancingenabled      => '1',
    messagesmaximum           => '10',
    reconnectpolicy           => 'producer',
    serveraffinityenabled     => '1',
    subscriptionsharingpolicy => 'Exclusive',
    transactiontimeout        => '3600',
  }


  wls_jms_connection_factory { "${domain_name}/jmsClusterModule:cf":
    defaulttargeting          => '0',
    jndiname                  => 'jms/cf',
    subdeployment             => 'wlsServers',
    xaenabled                 => '0',
  }

  wls_jms_connection_factory { "${domain_name}/jmsClusterModule:cf2":
    defaulttargeting          => '1',
    jndiname                  => 'jms/cf2',
    xaenabled                 => '1',
  }

  Wls_jms_queue {
    ensure            => 'present',
    balancingpolicy   => 'Round-Robin',
    consumptionpaused => '0',
    defaulttargeting  => '0',
    deliverymode      => 'No-Delivery',
    distributed       => '1',
    expirationpolicy  => 'Redirect',
    forwarddelay      => '-1',
    insertionpaused   => '0',
    productionpaused  => '0',
    redeliverydelay   => '2000',
    redeliverylimit   => '3',
    timetodeliver     => '-1',
    timetolive        => '300000',
  }

  wls_jms_queue { "${domain_name}/jmsClusterModule:ErrorQueue":
    expirationpolicy  => 'Discard',
    jndiname          => 'jms/ErrorQueue',
    redeliverydelay   => '-1',
    redeliverylimit   => '-1',
    subdeployment     => 'jmsServers',
    timetodeliver     => '-1',
    timetolive        => '-1',
  }

  wls_jms_queue { "${domain_name}/jmsClusterModule:Queue1":
    errordestination  => 'ErrorQueue',
    expirationpolicy  => 'Redirect',
    jndiname          => 'jms/Queue1',
    subdeployment     => 'jmsServers',
  }

  wls_jms_queue { "${domain_name}/jmsClusterModule:Queue2":
    consumptionpaused       => '1',
    expirationloggingpolicy => '%header%%properties%',
    expirationpolicy        => 'Log',
    insertionpaused         => '1',
    jndiname                => 'jms/Queue2',
    productionpaused        => '1',
    subdeployment           => 'jmsServers',
  }

  wls_jms_topic { "${domain_name}/jmsClusterModule:Topic1":
    ensure            => 'present',
    balancingpolicy   => 'Round-Robin',
    consumptionpaused => '0',
    defaulttargeting  => '0',
    deliverymode      => 'No-Delivery',
    distributed       => '1',
    expirationpolicy  => 'Discard',
    forwardingpolicy  => 'Replicated',
    insertionpaused   => '0',
    jndiname          => 'jms/Topic1',
    productionpaused  => '1',
    redeliverydelay   => '2000',
    redeliverylimit   => '2',
    subdeployment     => 'jmsServers',
    timetodeliver     => '-1',
    timetolive        => '300000',
  }

}