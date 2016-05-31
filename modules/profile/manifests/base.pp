class profile::base()
{
  contain profile::base::config 
  contain profile::base::hosts
  contain profile::base::packages
}