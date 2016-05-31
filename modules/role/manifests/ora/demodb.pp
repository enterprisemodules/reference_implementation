class role::ora::demodb()
{
  contain profile::base
  contain profile::ora::os
  contain profile::ora::software
  contain profile::ora::patches
  contain profile::ora::demodb

  Class['profile::base::hosts']
  -> Class['profile::ora::os']
  -> Class['profile::ora::software']
  -> Class['profile::ora::patches']
  -> Class['profile::ora::demodb']
}