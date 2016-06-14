class profile::ora::patches(
  String $oracle_home,
  String $dbname,
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

  $patch_list = ora_physical_patches($patch_resources)

  if ora_patches_installed($patch_list) {
    notice "All patches installed."
  } else {

    $patch_defaults = {
      ensure     => 'present',
      os_user    => 'oracle',
      ocmrf_file => "${oracle_home}/OPatch/ocm.rsp",
      before     => Db_control["start_${dbname}_after_patching"],
      require    => [
          Ora_install::Opatchupgrade['opatch_upgrade'],
          Db_control["stop_${dbname}_before_patching"],
        ],
    }

    #
    # Only start the database here if it was also stopped here
    # else we leave it to the normal flow.
    #
    db_control{"stop_${dbname}_before_patching":
      ensure                  => 'stop',
      instance_name           => $dbname,
      oracle_product_home_dir => $oracle_home,
      os_user                 => 'oracle',
      notify                  => Db_control["start_${dbname}_after_patching"],
    }

    create_resources('ora_opatch', $patch_resources, $patch_defaults)

    db_control{"start_${dbname}_after_patching":
      ensure                  => 'start',
      instance_name           => $dbname,
      oracle_product_home_dir => $oracle_home,
      refreshonly             => true,
      os_user                 => 'oracle',
    }


  }

}