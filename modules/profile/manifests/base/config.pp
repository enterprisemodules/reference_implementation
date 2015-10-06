class profile::base::config()
{
  class { 'timezone':
    timezone => 'Europe/Amsterdam',
  }  
}