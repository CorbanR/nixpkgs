# frozen_string_literal: true

Vagrant.configure('2') do |config|
  config.vm.box = 'ramsey/macos-catalina'
  config.vm.synced_folder '.', '/vagrant', disabled: true
  config.vm.box_version = '1'
  #config.vm.network 'private_network', type: 'dhcp'

  config.vm.provider :virtualbox do |vb, _override|
    #vb.gui = true
    vb.customize ['modifyvm', :id, '--memory', '8192']
    vb.customize ['modifyvm', :id, '--cpus', '4']
  end
end
