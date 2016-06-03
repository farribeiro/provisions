# kickstart template for Fedora 8 and later.
# (includes %end blocks)
# do not use with earlier distros

#platform=x86, AMD64, or Intel EM64T
# System authorization information
auth  --useshadow  --enablemd5
# System bootloader configuration
bootloader --location=mbr
# Partition clearing information
clearpart --all --initlabel
# Use text mode install
text
# Firewall configuration
firewall --enabled
# Run the Setup Agent on first boot
firstboot --disable
# System keyboard
keyboard us
# System language
lang pt_BR
# Use network installation
url --url=$tree
# If any cobbler repo definitions were referenced in the kickstart profile, include them here.
$yum_repo_stanza
# Network information
$SNIPPET('network_config')
# Reboot after installation
reboot

#Root password
rootpw --iscrypted $default_password_crypted
# SELinux configuration
selinux --permissive
# Do not configure the X Window System
skipx
# System timezone
timezone  America/Sao_Paulo
# Install OS instead of upgrade
install
# Clear the Master Boot Record
zerombr
# Allow anaconda to partition the system as needed
autopart

%pre
$SNIPPET('log_ks_pre')
$SNIPPET('kickstart_start')
$SNIPPET('pre_install_network_config')
# Enable installation monitoring
$SNIPPET('pre_anamon')
%end

%packages
$SNIPPET('func_install_if_enabled')
@Development Tools
man
heartbeat
ntp
ntpdate
#puppet
htop
tmux
heartbeat
sudo
ntp
ntpdate
#"nss-pam-ldapd",
#"krb5-workstation",
#"pam_krb5",
#"nscd",
#"openldap-clients",
mutt
net-snmp
net-tools
rsync
at
epel-release
openvm-tools-nox11
aria2
dnf
%end

%post
$SNIPPET('log_ks_post')
# Start yum configuration
$yum_config_stanza
# End yum configuration
$SNIPPET('post_install_kernel_options')
$SNIPPET('post_install_network_config')
$SNIPPET('func_register_if_enabled')
$SNIPPET('download_config_files')
$SNIPPET('koan_environment')
$SNIPPET('redhat_register')
$SNIPPET('cobbler_register')
# Enable post-install boot notification
$SNIPPET('post_anamon')
# Start final steps
$SNIPPET('kickstart_done')
# End final steps
echo "net.ipv6.conf.all.disable_ipv6=1" >> /etc/sysctl.conf
echo "NOZEROCONF=YES" >> /etc/sysconfig/network
echo "GATEWAY=192.168.1.1" >> /etc/sysconfig/network
echo "nameserver 208.67.222.222" >> /etc/resolv.conf
echo "nameserver 208.67.220.220" >> /etc/resolv.conf
/sbin/chkconfig ip6tables off
/sbin/sysctl -p
#/bin/rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
#/bin/rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
%end
