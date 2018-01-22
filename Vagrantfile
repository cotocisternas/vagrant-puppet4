# -*- mode: ruby -*-
# vi: set ft=ruby :

## == required plugins and params == ##
# vagrant plugin install vagrant-hosts
# vagrant plugin install vagrant-cachier
# gem install fog-core --version 1.29.0
# gem install fog --version 1.29.0
# gem install veewee fog-libvirt
# gem install ruby-libvirt
# vagrant plugin install vagrant-libvirt
# export VAGRANT_DEFAULT_PROVIDER="libvirt"
##

Vagrant.configure('2') do |config|
  config.vm.box = 'debian/stretch64'
  config.vm.box_check_update = true

  config.vm.provider :libvirt do |kvm|
    kvm.random model: 'random'
    kvm.cpu_mode  = 'host-passthrough'
    kvm.driver    = 'kvm'
    kvm.memory    = 4096
    kvm.cpus      = 4
  end

  config.ssh.forward_agent = true

  puppets = {
    puppet01: { host: 'tx-puppet01-zz', ip: '172.16.211.10' }
  }

  nodes = {
    dns01: { host: 'tx-dns01-zz', ip: '172.16.211.2' },
    mon01: { host: 'tx-mon01-zz', ip: '172.16.211.5', mem: 8192 },
    # :dns02      => { host: 'tx-dns02-yy',          ip: '172.16.212.2' },
    # :dns03      => { host: 'tx-dns03-xx',          ip: '172.16.213.2' },
    # :mon03      => { host: 'tx-mon02-yy',          ip: '172.16.212.5', :mem => 8192 },
    # :mon02      => { host: 'tx-mon03-xx',          ip: '172.16.213.5', :mem => 8192 },
    cons01: { host: 'tx-consul01-zz', ip: '172.16.211.101' },
    # :cons02     => { host: 'tx-consul02-yy',       ip: '172.16.212.101' },
    # :cons03     => { host: 'tx-consul03-xx',       ip: '172.16.213.101' },
    # :vaul01     => { host: 'tx-vault01-zz',        ip: '172.16.211.111' },
    # :vaul02     => { host: 'tx-vault02-yy',        ip: '172.16.212.111' },
    # :vaul03     => { host: 'tx-vault03-xx',        ip: '172.16.213.111' },
    # :web01      => { host: 'au-dec5-web01-zz',     ip: '172.16.211.121' },
    # :web02      => { host: 'au-dec5qa-web01-zz',   ip: '172.16.211.122' },
    # :web03      => { host: 'au-dec5cap-web01-zz',  ip: '172.16.211.123' }
  }

  puppets.each do |name, options|
    config.vm.define name do |puppet|
      options[:domain] = 'autentia.systems' unless options[:domain]
      puppet.vm.hostname = "#{options[:host]}.#{options[:domain]}"
      puppet.vm.network :private_network,
                        ip: options[:ip],
                        autostart: true,
                        libvirt__domain_name: options[:domain],
                        libvirt__forward_mode: 'route',
                        libvirt__dhcp_enabled: false
      puppet.vm.provision :hosts do |provisioner|
        provisioner.autoconfigure = false
        provisioner.add_host '127.0.0.1', ["#{options[:host]}.#{options[:domain]}", options[:host], 'puppet']
      end

      puppet.vm.provision :shell, inline: "echo -e 'nameserver 8.8.8.8\nnameserver 8.8.4.4\n' > /etc/resolv.conf"
      puppet.vm.provision :shell, inline: "echo -e 'deb http://ftp.cl.debian.org/debian stretch main non-free contrib\n\ndeb http://ftp.cl.debian.org/debian-security/ stretch/updates main contrib non-free\n\ndeb http://deb.debian.org/debian stretch-backports main contrib non-free' > /etc/apt/sources.list"
      puppet.vm.provision :shell, inline: "echo -e 'Package: *\nPin: release a=stretch-backports\nPin-Priority: 500' > /etc/apt/preferences"
      puppet.vm.provision :shell, inline: 'apt-get update && apt-get -y install apt-transport-https zsh git curl && apt-get -y dist-upgrade'
      puppet.vm.provision :shell, path:   'master_conf/init.sh'
      puppet.vm.provision :shell, inline: '/opt/puppetlabs/bin/puppet resource package puppetserver ensure=latest'
      puppet.vm.provision :shell, inline: '/opt/puppetlabs/bin/puppet resource service puppetserver ensure=running enable=true'
      puppet.vm.provision :shell, inline: '/opt/puppetlabs/bin/puppet apply --modulepath=/vagrant/master_conf/modules /vagrant/master_conf/manifests/default.pp'
      puppet.vm.provision :shell, inline: '/opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true'
      puppet.vm.synced_folder 'puppet/data', '/etc/puppetlabs/code/environments/production/data', type: '9p'
      puppet.vm.synced_folder 'puppet/modules', '/etc/puppetlabs/code/environments/production/modules', type: '9p'
      puppet.vm.synced_folder 'puppet/site', '/etc/puppetlabs/code/environments/production/site', type: '9p'
      puppet.vm.provider :libvirt do |kvm|
        kvm.memory  = options[:mem] if options[:mem]
        kvm.cpus    = options[:cpu] if options[:cpu]
      end
    end
  end

  nodes.each do |name, options|
    config.vm.define name do |node|
      options[:domain] = 'autentia.systems' unless options[:domain]
      node.vm.hostname = "#{options[:host]}.#{options[:domain]}"
      node.vm.network :private_network,
                      ip: options[:ip],
                      autostart: true,
                      libvirt__domain_name: options[:domain],
                      libvirt__forward_mode: 'route',
                      libvirt__dhcp_enabled: false
      node.vm.provision :hosts do |provisioner|
        provisioner.autoconfigure = false
        provisioner.add_host '172.16.211.10', ['tx-puppet01-zz.autentia.services', 'tx-puppet01-zz', 'puppet']
        # provisioner.add_host '172.16.210.11', ['tx-puppet02-yy.autentia.services', 'tx-puppet02-yy', 'puppet']
        # provisioner.add_host '172.16.210.12', ['tx-puppet03-xx.autentia.services', 'tx-puppet03-xx', 'puppet']
      end
      node.vm.provision :shell, inline: "echo -e 'nameserver 8.8.8.8\nnameserver 8.8.4.4\n' > /etc/resolv.conf"
      node.vm.provision :shell, inline: "echo -e 'deb http://ftp.cl.debian.org/debian stretch main non-free contrib\n\ndeb http://ftp.cl.debian.org/debian-security/ stretch/updates main contrib non-free\n\ndeb http://deb.debian.org/debian stretch-backports main contrib non-free' > /etc/apt/sources.list"
      node.vm.provision :shell, inline: "echo -e 'Package: *\nPin: release a=stretch-backports\nPin-Priority: 500' > /etc/apt/preferences"
      node.vm.provision :shell, inline: 'apt-get update && apt-get -y install apt-transport-https zsh git curl && apt-get -y dist-upgrade'
      node.vm.provision :shell, path:   'master_conf/init.sh'
      node.vm.provision :shell, inline: '/opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true'
      node.vm.provider :libvirt do |kvm|
        kvm.memory  = options[:mem] if options[:mem]
        kvm.cpus    = options[:cpu] if options[:cpu]
      end
    end
  end
end
