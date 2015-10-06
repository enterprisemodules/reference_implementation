class role::ora::demodb()
{
  contain profile::base::config 
  contain profile::base::hosts
  contain profile::ora::os
  contain profile::ora::software
  contain profile::ora::demodb

  Class['profile::base::hosts'] ->
  Class['profile::ora::os'] ->
  Class['profile::ora::demodb']

}