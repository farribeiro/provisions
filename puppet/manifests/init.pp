class bootstrap {

	Exec {
		path	=> '/usr/bin:/usr/sbin:/bin:/usr/local/bin:/bin:/sbin',
	}

	host{ 'localhost':
		ip	=> '127.0.0.1',
		ensure	=> present,
	}

	$package_utils = [
	  - man
	  - links
	  - tmux
	  - corosync
	  - sudo
	  - puppet
	  - ntp
	  - ntpdate
		#'nss-pam-ldapd',
		#'krb5-workstation',
		#'pam_krb5',
		#'nscd',
		#'openldap-clients',
	  - mutt
	  - net-snmp
	  - rsync
	  - at
	  - git
	  - open-vm-tools
	  - epel-release
	  - net-tools
	  - iptraf
	  - bzip2
	  - unzip
	  - traceroute
	  - tcpdump
	  - ccze
	  - less
		#'most',
		#'dnsutils',
	  - nmap
	  - ruby­augeas
	  - tzdata
		]

	package { 'tzdata':
			ensure	=> lastest,
		}


	package {
		$package_utils:
			ensure	=> present,
	}

	package {
		[
	  - aria2
	  - tig
	  - htop
		]:
			ensure	=> present,
			require	=> Package['epel-release']
	}

	service { 'ntpd':
		ensure		=> running,
		enable		=> true,
		require		=> Package['ntp']
		# pattern	=> 'ntpd',
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


	file{ '/etc/ntp/ntp.conf':
		ensure	=> file,
		owner	=> 'root',
		group	=> 'root',
		mode	=> '0644',
		source	=> 'puppet:///modules/bootstrap/ntp.conf',
		notify	=> Service['ntpd'],
	}

	exec{'yum-update':
		command	=> 'yum update -y'
	}

	# include bootstrap::cloudstack
}
