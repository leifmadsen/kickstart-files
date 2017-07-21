#version=DEVEL
# System authorization information
auth --enableshadow --passalgo=sha512
# Use CDROM installation media
cdrom
# Use graphical install
graphical
# Run the Setup Agent on first boot
firstboot --disable
ignoredisk --only-use=sda
# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Install from the network
url --url=$tree

# Root password
rootpw --iscrypted $1$S7..3hRm3gh3rd/
# System services
services --enabled="chronyd"
# System timezone
timezone America/New_York --isUtc
user --groups=wheel --name=admin --password=$1$S7..3hRm3gh3rd/ --iscrypted --gecos="admin"

# System bootloader configuration
zerombr
clearpart --drives=sda --all --initlabel
part /boot --fstype ext4 --size=500
part swap --size=16384
# create physical volumes
part pv.01 --size=20480 --ondisk=sda
part pv.02 --size=50000 --grow --ondisk=sda
# create volume groups
volgroup vg_system pv.01
volgroup vg_gluster pv.02
# create logical volumes
logvol / --vgname=vg_system  --fstype=ext4  --size=10240 --grow --maxsize=15360 --name=lv_root
logvol /var --vgname=vg_system --fstype=ext4 --size=4096 --name=lv_var
logvol /tmp --vgname=vg_system --fstype=ext4 --size=1024 --name=lv_tmp
logvol /bricks/brick1 --vgname=vg_gluster --fstype=xfs --size=50000 --grow --name=lv_brick1

bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=sda

# Network information
$SNIPPET('network_config')
reboot

%pre
$SNIPPET('log_ks_pre')
$SNIPPET('kickstart_start')
$SNIPPET('pre_install_network_config')
# Enable installation monitoring
$SNIPPET('pre_anamon')
%end
