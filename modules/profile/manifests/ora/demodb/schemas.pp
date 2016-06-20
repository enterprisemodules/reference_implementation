class profile::ora::demodb::schemas(
  String  $schema_name,
){
  ora_user{"${schema_name}@${profile::ora::dbname}":
    ensure      => present,
    password    => $schema_name,
    quotas      => {
      'SYSTEM'  => 0,
      'DEMO_TS' => 'unlimited',
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