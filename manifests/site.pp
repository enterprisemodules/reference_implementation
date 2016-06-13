include stdlib                       # Make sure the standard functions are available
include em_utils::license::activate  # Always include the license class. This makes sure all the license files are copied
hiera_include('role')
