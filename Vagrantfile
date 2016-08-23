# -*- mode: ruby -*-
# vi: set ft=ruby :
#
require_relative './vm-scripts/vagrant_nodes'
extend VagrantNodes

VAGRANTFILE_API_VERSION = '2'.freeze

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.ssh.insert_key = false

    #
    # Load all node files
    #
    Dir.glob('./vm-defs/*.rb').each do |node_file|
        node_file_full = Pathname.new(node_file).expand_path.to_s
        vagrant_node node_file_full, binding
    end
end
