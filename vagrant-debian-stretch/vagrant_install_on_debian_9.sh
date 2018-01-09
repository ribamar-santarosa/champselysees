wget -c https://releases.hashicorp.com/vagrant/2.0.1/vagrant_2.0.1_x86_64.deb
sudo dpkg -i vagrant_2.0.1_x86_64.deb
sudo apt-get install libffi-dev libvirt-dev  nfs-kernel-server
sudo usermod --append --groups libvirt `whoami`
vagrant plugin install vagrant-mutate
vagrant plugin install vagrant-libvirt
sudo login
