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
img=$resized_img

# run again. try a different resolution, as video=800x600.  no_cdrom_option:
qemu-system-x86_64  -vga std -enable-kvm -m 1024    ${android_sleep_option} -monitor telnet:localhost:9393,server,nowait ${no_vnc_option} -drive file=${img},cache=none  ${no_cdrom_option}
