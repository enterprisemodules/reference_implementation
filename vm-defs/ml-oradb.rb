#
# This is a single node wls only system
#
alias_name = Pathname.new(__FILE__).basename('.rb').to_s
####################
#
# Change these settings for your node 
#
####################
settings = {}
settings[:memory] = 2048
settings[:num_cpus] = 1
settings[:virtualbox] = {}
settings[:virtualbox][:priv_ipaddress] = '10.10.10.20'
settings[:virtualbox][:domain_name] = 'example.com'


config.vm.define alias_name do |machine|
  #####################
  #
  # If you want/need extra hosts in the hostsfile, this is the place to be
  #
  #####################
  # machine.vm.provision :shell, :inline => "puppet apply -e \"host {'o3dbnode1.infoplus-ot.ris': ip => '10.100.0.128', host_aliases => ['o3dbnode1']}\""

  #
  # If you need any other stuff for the VM. This is the place
  #
  include_file 'masterless-vbox-vm', binding

end