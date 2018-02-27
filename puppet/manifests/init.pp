class bootstrap {

	Exec {
		path	=> '/usr/bin:/usr/sbin:/bin:/usr/local/bin:/bin:/sbin',
	}

	host{ 'localhost':
		ip	=> ['127.0.0.1', '::1'],
		ensure	=> present,
	}

	$package_utils = [
		# openvm-tools-nox11,
		# xzip,
		#dnf
		#krb5-workstation
		#net-tools
		#nscd
		#nss-pam-ldapd
		#openldap-clients
		#pam_krb5
		#puppet
		adcli,
		aria2,
		at,
		bzip2,
		ccze,
		corosync,
		epel-release,
		git,
		htop,
		iptraf,
		less,
		libselinux-python,
		links,
		man,
		most,
		mutt,
		net-snmp-utils,
		net-snmp,
		nmap,
		ntp,
		ntpdate,
		oddjob-mkhomedir,
		oddjob,
		open-vm-tools,
		pacemaker,
		rsync,
		samba-common,
		samba-winbind-clients,
		samba-winbind,
		sssd,
		sudo,
		tcpdump,
		tig,
		tmux,
		traceroute,
		tzdata,
		unbound,
		unzip,
	]

	package {
		$package_utils:
		ensure	=> present,
	}

	exec {'yum-update':
		command		=> 'yum update -y',
		refreshonly	=> true,
	}

	service{ 'sshd':
		ensure	=> running,
		enable	=> present,
	}

	service { 'ntpd':
		ensure		=> running,
		enable		=> true,
		require		=> Package['ntp']
		# pattern	=> 'ntpd',
	}

	file{ '/etc/ntp.conf':
		ensure	=> file,
		owner	=> 'root',
		group	=> 'root',
		mode	=> '0644',
		source	=> 'puppet:///modules/bootstrap/ntp.conf',
		notify	=> Service['ntpd'],
	}

	service { 'firewalld':
		ensure		=> stopped,
		enable		=> false,
		# pattern	=> 'firewalld',
	}

	# yumrepo { 'local':
		# ensure	=> present,
		# baseurl	=> 'http://192.168.1.29/',
		# descr		=> 'The local repository',
		# enabled	=> '1',
		# gpgcheck	=> '1',
		# gpgkey	=> 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-local',
		# mirrorlist	=> '',
	# }

	service { 'unbound':
		ensure	=> running,
		enable	=> true,
	}

	file { '/etc/unbound/unbound.conf':
		ensure	=> file,
		owner	=> 'root',
		group	=> 'root',
		mode	=> '0644',
		source	=> 'puppet:///modules/bootstrap/unbound.conf',
		notify	=> Service['unbound'],
	}

	service {'NetworkManager':
		ensure	=> running,
		enable	=> true,
	}

	file { '/etc/NetworkManager/NetworkManager.conf':
		ensure	=> file,
		owner	=> 'root',
		group	=> 'root',
		mode	=> '0644',
		source	=> 'puppet:///modules/bootstrap/NetworkManager.conf',
		notify	=> Service['NetworkManager'],
	}

	$domain		= [ 'bradw01.local' ]
	$domain_u	= [ 'BRADW01.LOCAL ' ]
	$user_ad	= [ '' ]
	$pwd_ad		= [ '' ]

	exec{ 'authconfig':
		command => '
			authconfig \
			--enablekrb5 \
			--krb5kdc=$domain \
			--krb5adminserver=$domain_u \
			--krb5realm=$domain \
			--enablesssd \
			--enablesssdauth \
			--update
		',
		refreshonly	=> true,
		before		=> Exec['join-ad'],
	}

	exec{ 'join-ad':
		command		=> 'adcli join $domain -U $user_ad -p $pwd_ad',
		refreshonly	=> true,
	}

	service { 'sssd':
		ensure	=> running,
		enable	=> true,
	}

	file { '/etc/sssd/sssd.conf':
		ensure	=> file,
		owner	=> 'root',
		group	=> 'root',
		mode	=> '0600',
		source	=> 'puppet:///modules/bootstrap/sssd.conf',
		require	=> Package['sssd'],
	}

	file { '/etc/pam.d/system-auth':
		ensure	=> present,
	}

	exec { 'add-pamd':
		command		=> 'echo "session	optional	pam_mkhomedir.so skel=/etc/skel umask=077" >> /etc/pam.d/system-auth',
		notify		=> Service['sssd'],
	}

	service { 'winbind':
		ensure	=> running,
		enable	=> true,
	}

	exec { 'keygen-ssh':
		command		=> 'ssh-keygen -t rsa',
		notify		=> Exec['copy-ssh'],
	}

	$ip_machine_bk = [''],

	exec { 'copy-ssh':
		command		=> 'ssh-copy-id $ip_machine_bk',
		notify		=> Exec['coro-keygen'],
	}

	exec { 'coro-keygen':
		command		=> 'corosync -keygen',
		refreshonly	=> true,
		# notify	=> Exec['send-key'],
	}

	# exec { 'send-key'
		# command	=> 'scp /etc/corosync/authkey $ip_machine_bk:/etc/corosync/authkey',
		# notify	=> Exec[']
	# }

	file { '/etc/default/corosync':
		ensure	=> file,
		owner	=> 'root',
		group	=> 'root',
		mode	=> '0644',
		notify	=> Exec['sed-corosync'],
		puppet	=> 'puppet:///modules/bootstrap/corosync'
	}

	# exec { 'sed-corosync':
		# command	=> 'sed -i 's/START=no/START=yes/g' /etc/default/corosync',
		# notify	=>
	}

	service { 'corosync':
		ensure	=> running,
		enable	=> true,
	}

	file { '/etc/ssh/sshd_config':
		ensure	=> file,
		owner	=> 'root',
		group	=> 'root',
		mode	=> '0644',
	}
	
	file { '/etc/corosync/corosync.conf':
		ensure	=> file,
		owner	=> 'root',
		group	=> 'root',
		mode	=> '0644',
		source	=> 'puppet:///modules/bootstrap/corosync.conf',
		notify	=> Service['corosync'],
	
	}

	exec { 'sshd-groups':
		command		=> 'echo "AllowGroups linuxadmins" >> /etc/ssh/sshd_config',
		refreshonly	=> true,
		notify		=> Service['sshd'],
	}
}
