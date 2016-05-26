#
# This profile class manages a single datasource
#
# @example usage inside a role class
#   include profile::wls::wlsonly::dstasources::ds-0
#
# @param host [String]  The host to connect to
# @param database [String] The database name to connect o
# @param username [String] The schema to connect to
# @param password [String] The password of the schema
#
class profile::wls::wlsonly::datasources::ds0(
  String  $host,
  String  $database,
  String  $username,
  String  $password,
)
{
  #
  # Uncomment this if you want to define the datasource. 
  #
  # wls_datasource { 'wlsonly/ds-0':
  #   ensure                           => 'present',
  #   connectioncreationretryfrequency => '0',
  #   drivername                       => 'oracle.jdbc.xa.client.OracleXADataSource',
  #   fanenabled                       => '0',
  #   globaltransactionsprotocol       => 'TwoPhaseCommit',
  #   initialcapacity                  => '1',
  #   maxcapacity                      => '15',
  #   mincapacity                      => '1',
  #   # password                         =>  $password,
  #   rowprefetchenabled               => '0',
  #   rowprefetchsize                  => '48',
  #   secondstotrustidlepoolconnection => '10',
  #   shrinkfrequencyseconds           => '900',
  #   statementcachesize               => '10',
  #   testconnectionsonreserve         => '0',
  #   testfrequency                    => '120',
  #   testtablename                    => 'SQL ISVALID',
  #   url                              => "jdbc:oracle:thin:@${host}:1521:${database}",
  #   user                             => $username,
  #   usexa                            => '1',
  #   wrapdatatypes                    => '1',
  #   target                           => ['wlsCluster'],
  #   targettype                       => [ 'Cluster'],
  #   xaproperties                     => ['KeepXaConnTillTxComplete=1', 'XaSetTransactionTimeout=0', 'KeepLogicalConnOpenOnRelease=0', 'ResourceHealthMonitoring=1', 'XaEndOnlyOnce=0', 'XaRetryDurationSeconds=0', 'NeedTxCtxOnClose=0', 'NewXaConnForCommit=0', 'XaTransactionTimeout=0', 'RecoverOnlyOnce=0', 'XaRetryIntervalSeconds=60', 'RollbackLocalTxUponConnClose=0'],
  # }
}
