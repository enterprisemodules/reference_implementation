machine.vm.provider :virtualbox do |vb, override|

  alias_name      = alias_name.split('-').last
  hostname = "#{alias_name}.#{settings[:virtualbox][:domain_name]}"
  override.vm.box = "enterprisemodules/centos-7.2-x86_64-nocm"

  puppet_installer = "puppet-enterprise-2016.1.2-el-7-x86_64/puppet-enterprise-installer"

  vb.customize ["modifyvm", :id, "--memory", settings[:memory]]
  vb.customize ["modifyvm", :id, "--name", alias_name]
  vb.customize ["modifyvm", :id, "--cpus", settings[:num_cpus]]
  vb.customize ["modifyvm", :id, "--ioapic", "on"]
  vb.customize ["modifyvm", :id, "--nic3", "intnet"]

  override.vm.hostname = hostname
  override.vm.network :private_network, ip: settings[:virtualbox][:priv_ipaddress]

  #
  # Fix hostnames because Vagrant mixes it up.
  #
  override.vm.provision :shell, :inline => <<-EOD
cat > /etc/hosts<< "EOF"
127.0.0.1 localhost.localdomain localhost4 localhost4.localdomain4
10.10.10.10 master.example.com puppet master
#{settings[:virtualbox][:priv_ipaddress]} #{hostname} #{alias_name}
EOF
EOD
  #
  # First we need to instal the agent. 
  #
  override.vm.provision :shell, :inline => "curl -k https://master.example.com:8140/packages/current/install.bash | sudo bash"
  #
  # The agent installation also automatically start's it. In production, this is what you want. For now we 
  # want the first run to be interactive, so we see the output. Therefore, we stop the agent and wait 
  # for it to be stopped before we start the interactive run 
  #
  override.vm.provision :shell, :inline => 'pkill -9 -f "puppet.*agent.*"'
  override.vm.provision :shell, :inline => "puppet agent -t; exit 0"
  #
  # After the interactive run is done, we restart the agent in a normal way.
  #
  override.vm.provision :shell, :inline => "systemctl start puppet"
end
