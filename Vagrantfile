Vagrant.configure("2") do |config|
  
  config.vm.provider :virtualbox do |vb|
    vb.memory = 1048
    vb.cpus = 2
  end
  
  config.vm.box = "bento/debian-13.1"
  config.vm.box_version = "202510.26.0"

  config.vm.provision "shell", inline: "swapoff -a; sed -i '/\sswap\s/s/^/#/' /etc/fstab;"

  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.define "cloud-1" do |machine|
    machine.vm.hostname = "cloud-1"
    machine.vm.network "private_network", ip: "192.168.56.110", hostname: true
   
    machine.vm.provider :virtualbox do |vb|
      vb.name = "cloud-1"
      target_folder = "/sgoinfre/almarcos/debian_vagrant/"
      vb.customize ["setproperty", "machinefolder", target_folder]
    end

  end
end
