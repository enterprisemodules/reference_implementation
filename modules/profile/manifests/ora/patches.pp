class profile::ora::patches(
  String $oracle_home,
  Hash   $patch_resources,     # Contains a Hash of patches to apply
)
{
  #
  # To apply te right patches we need a current version of the Opatch utility
  # The resource statement takes care of this.
  #
  ora_install::opatchupgrade { 'opatch_upgrade':
    oracle_home               => $oracle_home,
    opversion                 => '12.1.0.1.12',
    patch_file                => 'p6880880_121010_Linux-x86-64.zip',
    puppet_download_mnt_point => '/vagrant/software',
  }

  $patch_list = $patch_resources.keys

  if ora_patches_installed($patch_list) {
    notice "All patches installed."
    $needs_shutdown = false
  } else {
    $needs_shutdown = false
  }

  $patch_defaults = {
    ensure     => 'present',
    os_user    => 'oracle',
    ocmrf_file => "${oracle_home}/OPatch/ocm.rsp",
    require    => Ora_install::Opatchupgrade['opatch_upgrade'],
  }

  create_resources('ora_opatch', $patch_resources, $patch_defaults)

}