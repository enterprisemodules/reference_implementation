class profile::base::packages()
{

	$required_package = [
		'bc',
		'mlocate',
		'psmisc',
	]

	package{ $required_package:
		ensure => 'installed',
	}

}