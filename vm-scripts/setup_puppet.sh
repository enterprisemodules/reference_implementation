#
# Install librarian puppet. We need this to download the correct set of puppet modules
#
echo 'Installing required gems'
/opt/puppetlabs/puppet/bin/gem install librarian-puppet awesome_print --no-rdoc --no-ri

echo 'Installing required puppet modules'
cd /vagrant
/opt/puppetlabs/puppet/bin/librarian-puppet install

#
# Setup hiera search and backend. We need this to config our systems
#
echo 'Setting up hiera directories'
ln -sf /vagrant/hiera.yaml /etc/puppetlabs/code/hiera.yaml

dirname=/etc/puppetlabs/code/environments/production/hieradata
if [ -d $dirname ]; then
  rm -rf $dirname
else
  rm -f $dirname
fi
ln -sf /vagrant/hieradata /etc/puppetlabs/code/environments/production

#
# Configure the puppet path's 
#
echo 'Setting up Puppet module directories'
dirname=/etc/puppetlabs/code/environments/production/modules
if [ -d $dirname ]; then
  rm -rf $dirname
else
  rm -f $dirname
fi
ln -sf /vagrant/modules /etc/puppetlabs/code/environments/production


echo 'Setting up Puppet manifest directories'
dirname=/etc/puppetlabs/code/environments/production/manifests
if [ -d $dirname ]; then
  rm -rf $dirname
else
  rm -f $dirname
fi
ln -sf /vagrant/manifests /etc/puppetlabs/code/environments/production


