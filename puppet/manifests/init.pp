class bootstrap {

	Exec {
		path	=> '/usr/bin:/usr/sbin:/bin:/usr/local/bin:/bin:/sbin',
	}

	host{ 'localhost':
		ip	=> '127.0.0.1',
		ensure	=> present,
	}

	$package_utils = [
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
		net-snmp,
		net-snmp-utils,
		nmap,
		ntp,
		ntpdate,
		open-vm-tools,
		# openvm-tools-nox11,
		rsync,
		sudo,
		tcpdump,
		tig,
		tmux,
		traceroute,
		tzdata,
		unzip,
		# xzip,
		#openldap-clients
		#dnf
		#krb5-workstation
		#net-tools
		#nscd
		#nss-pam-ldapd
		#pam_krb5
		#puppet
	]

	package {
		$package_utils:
		ensure	=> present,
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


		ensure	=> file,
		owner	=> 'root',
		group	=> 'root',
		mode	=> '0644',
	}

	exec{'yum-update':
		command	=> 'yum update -y'
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
