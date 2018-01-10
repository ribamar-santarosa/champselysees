# vagrant_debian_stretch.sh

Encapsulates `vagrant` commands to run the `debian/stretch64` (set `base_img`
in the code for others).

Basic case:
````
# 1 - install qemu (not yet explained here)
# 2 - install vagrant (or do it manually):
./vagrant_install_on_debian_9.sh
# 3 - run an img:
./vagrant_debian_stretch.sh
# 4 -  ssh into your very own virtual machine:
vagrant ssh
````

## Pre-requisites

`vagrant` and `qemu` installed and running in the machine. Of course, that
is the hard part.

I won't describe how to get `qemu` running here now. If you can get the subproject
https://github.com/ribamar-santarosa/champselysees/tree/master/android-on-linux
running, you have the pre-requisites.

Vagrant -- In my debian stretch (9.1.0), I had to:

````
wget -c https://releases.hashicorp.com/vagrant/2.0.1/vagrant_2.0.1_x86_64.deb
sudo dpkg -i vagrant_2.0.1_x86_64.deb
sudo apt-get install libffi-dev libvirt-dev  nfs-kernel-server
sudo usermod --append --groups libvirt `whoami`
vagrant plugin install vagrant-mutate
vagrant plugin install vagrant-libvirt
sudo login
````

These steps are in `./vagrant_install_on_debian_9.sh`


Also, I alert you that I had a key password id_rsa in my `~/.ssh`.
Removing it -- not the ideal solution, but as a proof of concept
-- allowed me to ssh to the image.


