class profile::java(
  String $version,
  String $full_version,
  String $cryptography_extension_file,
)
 {
  $remove = [ "java-1.7.0-openjdk.x86_64", "java-1.6.0-openjdk.x86_64" ]

  package { $remove:
    ensure  => absent,
  } ->

  jdk7::install7{ "jdk-${version}-linux-x64":
    version                     => $version ,
    full_version                => $full_version,
    alternatives_priority       => 18001,
    x64                         => true,
    download_dir                => "/var/tmp/install",
    urandom_java_fix            => true,
    rsa_key_size_fix            => true,
    cryptography_extension_file => $cryptography_extension_file,
    source_path                 => "/vagrant/software"
  }
}



