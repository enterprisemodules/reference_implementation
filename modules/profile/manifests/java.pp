class profile::java {
  $remove = [ "java-1.7.0-openjdk.x86_64", "java-1.6.0-openjdk.x86_64" ]

  package { $remove:
    ensure  => absent,
  } ->

  jdk7::install7{ 'jdk-8u74-linux-x64':
    version                     => "8u74" ,
    full_version                => "jdk1.8.0_74",
    alternatives_priority       => 18001,
    x64                         => true,
    download_dir                => "/var/tmp/install",
    urandom_java_fix            => true,
    rsa_key_size_fix            => true,
    cryptography_extension_file => "jce_policy-8.zip",
    source_path                 => "/vagrant/software"
  }
}



