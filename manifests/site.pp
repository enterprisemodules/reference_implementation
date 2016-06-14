include stdlib                       # Make sure the standard functions are available
include em_utils::license::activate  # Always include the license class. This makes sure all the license files are copied
hiera_include('role')

#
# This is the schedule used for applying patches. The databases and WebLogic instances
# might go down during these times. 
#
schedule { 'maintenance-window':
  range  => "2:00 - 4:00"  # Change to your requirements
}
