#version=RHEL7
# System authorization information
auth --useshadow  --enablemd5
# Install OS instead of upgrade
install
url --url http://titan.int.aci.ics.psu.edu/pulp/repos/ICS-ACI/Library/content/dist/rhel/server/7/7.2/x86_64/kickstart/
# Reboot after installation
reboot --eject
# Use text mode install
text
# Firewall configuration
firewall --disabled
firstboot --disable
ignoredisk --only-use=sda

keyboard us

# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp
network  --hostname=localhost.localdomain
# Root password
rootpw --iscrypted $1$damlkd,f$UC/u5pUts5QiU3ow.CSso/
# SELinux configuration
selinux --enforcing

# System timezone
timezone UTC --isUtc

# System bootloader configuration
bootloader --location=mbr --boot-drive=sda
autopart --type=lvm
# Clear the Master Boot Record
zerombr
# Partition clearing information
clearpart --all --initlabel 

# Repos
repo --name Titan --baseurl=http://titan.int.aci.ics.psu.edu/pulp/repos/ICS-ACI/Library/custom/Atomic_OSSEC/Atomic_OSSEC_EL7_x86_64/


%packages --ignoremissing
@core
@Development Tools
bzip2
curl
@gnome-desktop
gnome-apps
@kde-desktop
gcc
kernel-devel
kernel-headers
make
net-tools
nfs-utils
patch
perl
wget
ossec-hids
ossec-hids-client
inotify-tools
vagrant
firefox
google-chrome
%end

%post
# Add vagrant user and give it passwordless, tty-less sudo.
/usr/sbin/groupadd vagrant
/usr/sbin/useradd vagrant -g vagrant -G wheel
echo "vagrant"|passwd --stdin vagrant
echo "%vagrant ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/vagrant
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
chmod 0440 /etc/sudoers.d/vagrant
%end
