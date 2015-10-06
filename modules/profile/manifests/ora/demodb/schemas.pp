class profile::ora::demodb::schemas(
  String  $schema_name,
  String $dbname,
){
  ora_user{"${schema_name}@${dbname}":
    ensure     => present,
    password   => $schema_name,
    quotas     => {
      'SYSTEM' => 0,
      'DEMO'   => 'unlimited',
    },
    grants    => [
      'CONNECT'
    , 'CREATE TABLE'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE'
    , 'CREATE VIEW'
    , 'CREATE SEQUENCE'
    , 'QUERY REWRITE'
    , 'CREATE PROCEDURE'
    , 'SELECT_CATALOG_ROLE'
    ],
  } 
}