class profile::ora::demodb
{
  contain profile::ora::demodb::database
  contain profile::ora::demodb::tablespaces
  contain profile::ora::demodb::schemas

  Class['profile::ora::os'] ->
  Class['profile::ora::software'] ->
  Class['profile::ora::demodb::database'] ->
  Class['profile::ora::demodb::tablespaces'] ->
  Class['profile::ora::demodb::schemas']
}