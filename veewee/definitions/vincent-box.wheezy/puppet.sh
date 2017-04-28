# Prepare puppetlabs repo
wget http://apt.puppetlabs.com/puppetlabs-release-wheezy.deb
dpkg -i puppetlabs-release-wheezy.deb
apt-get update

# Install puppet/facter
apt-get -y install puppet facter ruby1.9.1 ruby1.9.1-dev rubygems1.9.1 irb1.9.1 ri1.9.1 rdoc1.9.1 build-essential libopenssl-ruby1.9.1 libssl-dev zlib1g-dev build-essential libxslt1-dev libxml2-dev zlib1g-dev
sed -i '/templatedir/d' /etc/puppet/puppet.conf
sed -i 's/START=no/START=yes/g' /etc/default/puppet