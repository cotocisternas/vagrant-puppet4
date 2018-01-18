wget --no-check-certificate -c https://apt.puppetlabs.com/puppet5-release-stretch.deb -O /tmp/puppet.deb
dpkg -i /tmp/puppet.deb
apt-get update
apt-get -y install puppet-agent
