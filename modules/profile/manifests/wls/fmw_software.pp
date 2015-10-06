class profile::wls::fmw_software(
  Integer $version,
  String  $filename,
) {

  wls_install::fmw{$filename:
    version      => $version,
    fmw_file1    => $filename,
    fmw_product  => 'soa',
    bpm          => true,
    remote_file  => false,
    source       => '/vagrant/software',
    log_output   => true,
  }
}
