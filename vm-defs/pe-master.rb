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
settings[:virtualbox][:priv_ipaddress] = '10.10.10.10'
settings[:virtualbox][:domain_name] = 'example.com'

#
# Choose your version of Puppet Enterprise
#
# puppet_installer   = "puppet-enterprise-2015.3.0-el-6-x86_64/puppet-enterprise-installer"
# puppet_installer   = "puppet-enterprise-2015.2.2-el-6-x86_64/puppet-enterprise-installer"
# puppet_installer   = "puppet-enterprise-2016.1.2-el-7-x86_64/puppet-enterprise-installer"
puppet_installer   = "puppet-enterprise-2016.2.1-el-7-x86_64/puppet-enterprise-installer"

pe_puppet_user_id  = 495
pe_puppet_group_id = 496

config.vm.define alias_name do |machine|
  #####################
  #
  # If you want/need extra hosts in the hostsfile, this is the place to be
  #
  #####################
  # machine.vm.provision :shell, :inline => "puppet apply -e \"host {'o3dbnode1.infoplus-ot.ris': ip => '10.100.0.128', host_aliases => ['o3dbnode1']}\""

  machine.vm.provider :virtualbox do |vb, override|

    hostname = "#{alias_name.split('-').last}.#{settings[:virtualbox][:domain_name]}"
    override.vm.box = "puppetlabs/centos-7.2-64-nocm"


    vb.customize ["modifyvm", :id, "--memory", settings[:memory]]
    vb.customize ["modifyvm", :id, "--name", alias_name]
    vb.customize ["modifyvm", :id, "--cpus", settings[:num_cpus]]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
    vb.customize ["modifyvm", :id, "--nic3", "intnet"]

    override.vm.hostname = hostname
    override.vm.network :private_network, ip: settings[:virtualbox][:priv_ipaddress]

    override.vm.synced_folder ".", "/vagrant", :owner => pe_puppet_user_id, :group => pe_puppet_group_id
    override.vm.provision :shell, :inline => "/vagrant/software/#{puppet_installer} -c /vagrant/pe.conf -y"
    #
    # For this vagrant setup, we make sure all nodes in the domain examples.com are autosigned. In production
    # you'dd want to explicitly confirm every node.
    #
    override.vm.provision :shell, :inline => "echo '*.example.com' > /etc/puppetlabs/puppet/autosign.conf"
    #
    # For now we stop the firewall. In the future we will add a nice puppet setup to the ports needed
    # for Puppet Enterprise to work correctly.
    #
    override.vm.provision :shell, :inline => "systemctl stop firewalld.service"
    override.vm.provision :shell, :inline => "systemctl disable firewalld.service"
    #
    # This script make's sure the vagrant paths's are symlinked to the paces Puppet Enterprise looks for specific
    # modules, manifests and hiera data. This makes it easy to change these files on your host operating system.
    #
    override.vm.provision :shell, :path => "vm-scripts/setup_puppet.sh"
    #
    # Make sure all plugins are synced to the puppetserver before exiting and stating
    # any agents
    #
    override.vm.provision :shell, :inline => "service pe-puppetserver restart"
    override.vm.provision :shell, :inline => "puppet agent -t || true"
  end

end
