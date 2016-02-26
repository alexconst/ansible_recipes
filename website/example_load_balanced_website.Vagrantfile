# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  # Choose a box with VBox guest tools already installed
  #config.vm.box = "debian/jessie64"
  config.vm.box = "ubuntu/wily64"

  # Set up hostname
  config.vm.hostname = "ansible-nginx"

  # Message shown on vagrant up
  config.vm.post_up_message = "After provisioning check the website at http://localhost:8080/"

  # Share an additional folder with the guest VM.
  host_folder = ENV['HOME'] + "/home/downloads/share_vagrant"
  guest_folder = "/shared/"
  config.vm.synced_folder host_folder, guest_folder

  # Fine tune the virtualbox VM
  config.vm.provider "virtualbox" do |vb|
    vb.customize [
      "modifyvm", :id,
      "--cpus", "2",
      "--cpuexecutioncap", "50",
      "--memory", "512",
    ]
  end

  # fix annoyance, http://foo-o-rama.com/vagrant--stdin-is-not-a-tty--fix.html
  config.vm.provision "fix-no-tty", type: "shell" do |s|
    s.privileged = false
    s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  end
  # fix annoyance, http://serverfault.com/questions/500764/dpkg-reconfigure-unable-to-re-open-stdin-no-file-or-directory
  config.vm.provision "shell", inline: "echo 'export DEBIAN_FRONTEND=noninteractive' >> /root/.profile"
  config.vm.provision "shell", inline: "for user in /home/*; do echo 'export DEBIAN_FRONTEND=noninteractive' >> $user/.profile; done"


  #####################################
  # multi-machine environment specific
  #####################################

  # web servers
  (1..2).each do |i|
    config.vm.define "web#{i}" do |web|
      web.vm.hostname = "web#{i}"
      # Assign a static IP to the guest
      web.vm.network :private_network, ip: "192.168.22.5#{i}"
      # Create a forwarded port mapping
      web.vm.network "forwarded_port", guest: 80, host: "808#{i}"
      # web server specific provisioning
      web.vm.provision :shell, inline: "echo 'Web Server #{web.vm.hostname} reporting for duty.'"
    end
  end

  # lb server
  config.vm.define "lb" do |lb|
    lb.vm.hostname = "lb"
    # Assign a static IP to the guest
    lb.vm.network :private_network, ip: "192.168.22.50"
    # Create a forwarded port mapping
    lb.vm.network "forwarded_port", guest: 80, host: "8080"
    # override default settings
    lb.vm.provider "virtualbox" do |vb|
      vb.memory = "256"
    end
    # lb server specific provisioning
    lb.vm.provision :shell, inline: "echo 'Load Balancer #{lb.vm.hostname} ready to distribute workload.'"
  end



  # provisioning using Ansible
  #config.vm.provision "ansible", playbook: "htop.yml"

end

