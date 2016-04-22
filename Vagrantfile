# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.provision 'shell', path: 'scripts/install-puppet.sh'
  config.vm.provision 'puppet' do |puppet|
    puppet.environment_path = 'puppet/environments'
    puppet.environment = 'production'
  end
end
