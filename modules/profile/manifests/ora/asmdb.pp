class profile::ora::asmdb
{
  contain profile::ora::asmdb::database
  # contain profile::ora::asmdb::tablespaces
  # contain profile::ora::asmdb::schemas

  # Class['profile::ora::asmdb::database'] ->
  # Class['profile::ora::asmdb::tablespaces'] ->
  # Class['profile::ora::asmdb::schemas']
}