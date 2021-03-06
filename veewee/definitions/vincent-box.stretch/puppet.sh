# Prepare puppetlabs repo
wget https://apt.puppetlabs.com/puppet5-release-jessie.deb
dpkg -i puppet5-release-jessie.deb
apt-get update

# Install puppet/facter
apt-get -y install puppet-agent ruby ruby-dev build-essential libssl-dev zlib1g-dev build-essential libxslt1-dev libxml2-dev zlib1g-dev
#sed -i '/templatedir/d' /etc/puppet/puppet.conf
sed -i 's/START=no/START=yes/g' /etc/default/puppet
