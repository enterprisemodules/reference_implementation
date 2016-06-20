class profile::ora::demodb::tablespaces(
  String $tablespace_name,
)
{
  include profile::ora

  ora_tablespace {"${tablespace_name}@${profile::ora::dbname}":
    ensure                   => present,
    datafile                 => $tablespace_name,
    size                     => '20M',
    logging                  => yes,
    autoextend               => on,
    next                     => '10M',
    max_size                 => '30M',
    extent_management        => local,
    segment_space_management => auto,
  }

}