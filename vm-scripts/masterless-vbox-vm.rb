machine.vm.provider :virtualbox do |vb, override|

  alias_name      = alias_name.split('-').last
  hostname        = "#{alias_name}.#{settings[:virtualbox][:domain_name]}"
  override.vm.box = "enterprisemodules/centos-6.6-64-puppet"

  vb.customize ["modifyvm", :id, "--memory", settings[:memory]]
  vb.customize ["modifyvm", :id, "--name", alias_name]
  vb.customize ["modifyvm", :id, "--cpus", settings[:num_cpus]]
  vb.customize ["modifyvm", :id, "--ioapic", "on"]
  vb.customize ["modifyvm", :id, "--nic3", "intnet"]

  override.vm.hostname = hostname
  override.vm.network :private_network, ip: settings[:virtualbox][:priv_ipaddress]

  override.vm.provision :shell, :path => "vm-scripts/setup_puppet.sh"
  #
  # And run puppet
  #
  override.vm.provision :shell, :inline => "puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp"

end
