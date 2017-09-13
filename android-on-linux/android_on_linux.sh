#/bin/bash
wget  -c http://bdownload.fosshub.com/programs/android-x86_64-6.0-r3.iso
wget -c http://cznic.dl.osdn.jp/android-x86/67834/android-x86_64-7.1-rc1.iso
android=android-x86_64-7.1-rc1
iso=android-x86_64-7.1-rc1.iso
android=android-x86-5.1-rc1
android=android-x86_64-6.0-r3
iso=${android}.iso
android_sleep_option=-no-acpi
vnc_option="-display vnc=:2,my_own_password"
no_vnc_option=""
cdrom_option="-cdrom ${iso} "
no_cdrom_option=""
base_size=1G # min 1GB for 6.0 and 7.1
resized_size=2G
extension=qcow2
extension=qcow2
base_img=${base_size}-base.${extension}
resized_img=${android}-${resized_size}.${extension}


# create a base image:
qemu-img create -f qcow2 $base_img $base_size
# Formatting '512M-base.qcow2', fmt=qcow2 size=536870912 encryption=off cluster_size=65536 lazy_refcounts=off 

# derive image. for the first time, it makes not much sense, but
# after you have android installed on an image, you can backup it, set it as base image, 
# and pick a new name for the $resized_img . So, it's easy to grow or shrink images. # Rezise not working todo
qemu-img create -f qcow2 $resized_img $resized_size
# Formatting 'x86_64-7.1-rc1-1G.qcow2', fmt=qcow2 size=1073741824 encryption=off cluster_size=65536 lazy_refcounts=off 
# qemu-img convert -O qcow2 $base_img $resized_img # todo: Not working
img=$resized_img

qemu-system-x86_64  -vga std -enable-kvm -m 1024 ${android_sleep_option}  -monitor telnet:localhost:9393,server,nowait ${no_vnc_option} -drive file=${img},cache=none  ${cdrom_option}
# select: installation TAB to edit options. 
# add video=1920x1080 . I certified running xrandr in my host that this resolution is supported. maybe this makes too slow
#  create/modify
# GPT: no
# New partition
# Primary
# takes all size 
# Set "Bootable" (confirm by checking the column "Flags")
# Write (important!)
# sure? yes
# quit
# OK (sda1)
# ext4
# all data lose: OK, sure
# boot loader? yes
# EFI grub2? Skip (i tried yes once and it was the cause of failure)
# format? yes
# /system as read-write: usually i say yes, but I am saying no this time to try to avoid the optimizing app issue
#  run or reboot


# install. now, with no_cdrom_option:
qemu-system-x86_64  -vga std -enable-kvm -m 1024    ${android_sleep_option} -monitor telnet:localhost:9393,server,nowait ${no_vnc_option} -drive file=${img},cache=none  ${no_cdrom_option}

#backup your hardwork
cp ${img} freshly_installed-${img}

# run again. try a different resolution, as video=800x600.  no_cdrom_option:
qemu-system-x86_64  -vga std -enable-kvm -m 1024    ${android_sleep_option} -monitor telnet:localhost:9393,server,nowait ${no_vnc_option} -drive file=${img},cache=none  ${no_cdrom_option}
