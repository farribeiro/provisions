class bootstrap {

	Exec {
		path	=> '/usr/bin:/usr/sbin:/bin:/usr/local/bin:/bin:/sbin',
	}

	host{ 'localhost':
		ip	=> '127.0.0.1',
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
		open-vm-tools,
		rsync,
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
}
