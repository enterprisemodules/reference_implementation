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
settings[:memory] = 3072
settings[:num_cpus] = 1
settings[:virtualbox] = {}
settings[:virtualbox][:priv_ipaddress] = '10.10.10.21'
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

  #
  # This is to bypass a VirtualBox error causing errors when installing Oracle.
  # Check https://www.virtualbox.org/ticket/14427
  #
  config.vm.provider :virtualbox do |vb|
    vb.customize ["setextradata", :id, "VBoxInternal/CPUM/HostCPUID/Cache/Leaf"        , "0x4"]
    vb.customize ["setextradata", :id, "VBoxInternal/CPUM/HostCPUID/Cache/SubLeaf"     , "0x4"]
    vb.customize ["setextradata", :id, "VBoxInternal/CPUM/HostCPUID/Cache/eax"         , "0"]
    vb.customize ["setextradata", :id, "VBoxInternal/CPUM/HostCPUID/Cache/ebx"         , "0"]
    vb.customize ["setextradata", :id, "VBoxInternal/CPUM/HostCPUID/Cache/ecx"         , "0"]
    vb.customize ["setextradata", :id, "VBoxInternal/CPUM/HostCPUID/Cache/edx"         , "0"]
    vb.customize ["setextradata", :id, "VBoxInternal/CPUM/HostCPUID/Cache/SubLeafMask" , "0xffffffff"]
  end  


  include_file 'masterless-vbox-vm', binding
  machine.vm.provider :virtualbox do |vb, override|
    override.vm.box = "OEL7_2-x86_64"
    override.vm.box_url = "https://dl.dropboxusercontent.com/s/0yz6r876qkps68i/OEL7_2-x86_64.box"
  end

end