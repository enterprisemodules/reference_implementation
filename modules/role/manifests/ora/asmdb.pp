class role::ora::asmdb()
{
  contain profile::base
  contain profile::grid::os
  contain profile::grid::nfs
  contain profile::grid::software
  contain profile::ora::software
  # contain profile::ora::patches
  contain profile::ora::asmdb

  Class['profile::base::hosts']
  -> Class['profile::grid::os']
  -> Class['profile::grid::nfs']
  -> Class['profile::grid::software']
  -> Class['profile::ora::software']
  # -> Class['profile::ora::patches']
  -> Class['profile::ora::asmdb']
}