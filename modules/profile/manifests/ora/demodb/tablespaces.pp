class profile::ora::demodb::tablespaces(
  String $tablespace_name,
  String $dbname,
){
  ora_tablespace {"${tablespace_name}@${dbname}":
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