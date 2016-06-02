# Requer modulo puppetlabs/mysql

class bootstrap::cloudstack{

	include bootstrap::bs

	host { 'cloudstack.bradw01.local':
		host_aliases	=> 'cloudstack',
		ip		=> '192.168.1.30',
		ensure		=> present,
		notify		=> Exec['sethostname']
	}

	exec { 'sethostname':
		command		=> 'hostnamectl set-hostname cloudstack.bradw01.local',
		refreshonly	=> true,
	}

	exec{ 'install-module':
		command		=> "puppet module install puppetlabs/mysql",
		refreshonly	=> true,
		before		=> Package['dnsmasq'],
	}

	package {'dnsmasq':
		ensure	=> present,
	}

	service{ 'dnsmasq':
		ensure	=> running,
		enable	=> true,
		hasrestart => true,
		hasstatus  => true,
		require	=> Package['dnsmasq'],
	}

	package { 'nfs-utils':
		ensure	=> present,
	}

	service { 'rpcbind':
		ensure	=> running,
		enable	=> true,
		hasrestart => true,
		hasstatus  => true,
		require	=> Package['nfs-utils'],
		before	=> Service['nfs-server'],
	}


	service { 'nfs-server':
		ensure	=> running,
		enable	=> true,
		hasrestart => true,
		hasstatus  => true,
		require	=> Package['nfs-utils'],
	}

	file { ['/exports', '/exports/primary', '/exports/secondary']:
		ensure	=> directory,
		owner	=> 'root',
		group	=> 'root',
		mode	=> '0775',

	}

	file { '/etc/exports':
		ensure	=> file,
		owner	=> 'root',
		group	=> 'root',
		mode	=> '0644',
		source	=> 'puppet:///modules/bootstrap/exports',
		notify	=> Service['nfs-server'],
	}

	# package { 'http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm':
		# ensure		=> present,
		# refreshonly	=> true,
	# }

	yumrepo { 'mysql56-community':
		ensure   => 'present',
		baseurl  => 'http://repo.mysql.com/yum/mysql-5.6-community/el/7/$basearch/',
		descr    => 'MySQL 5.6 Community Server',
		enabled  => '1',
		gpgcheck => '1',
		gpgkey   => 'file:/etc/pki/rpm-gpg/RPM-GPG-KEY-mysql',
	}

	# package{ 'mysql-community-server':
		# ensure	=> present,
	# }

	file { '/var/log/mariadb/':
		ensure	=> directory,
		owner	=> 'root',
		group	=> 'root',
	}

	# file { '/var/lib/mysql':
		# ensure	=> directory,
		# owner		=> 'mysql',
		# group		=> 'mysql',
		# recurse	=> true,
	# }

	class { 'mysql::server':
		root_password		=> 'password',
		package_name		=> 'mysql-community-server',
		service_name		=> 'mysql',
		manage_config_file	=> false,
		override_options	=> {
			'mysqld' => {
				'connect_timeout'		=> '60',
				'bind_address'			=> '0.0.0.0',
				'max_allowed_packet'		=> '512M',
				'thread_cache_size'		=> '16',
				'query_cache_size'		=> '128M',

				'innodb_roolback_on_timeout'	=> '1',
				'innodb_lock_wait_timeout'	=> '600',
				'max_connections'		=> '350',
				'log-bin'			=> 'mysql-bin',
				'binlog-format'			=> 'ROW',
		}}
	}

	yumrepo { 'cloudstack-4.5':
		ensure		=> 'present',
		descr		=> 'cloudstack',
		baseurl		=> 'http://packages.shapeblue.com/cloudstack/main/centos7/4.5',
		enabled		=> '1',
		gpgcheck	=> '0',
	}

	package { 'cloudstack-management.x86_64':
		ensure	=> present,
		require	=> Yumrepo['cloudstack-4.5'],
		notify	=> Exec['cs-sd'],
	}


	exec { 'cs-sd':
		command		=> 'cloudstack-setup-databases cloud:password@localhost --deploy-as=root:password -e file -m password -k password -i 192.168.1.30',
		# refreshonly	=> true,
		notify		=> Exec['cs-sm'],
	}

	exec { 'cs-sm':
		command		=> 'cloudstack-setup-management',
		refreshonly	=> true,
		# notify		=> Exec['mysqlupdates'],
	}

	file { '/tmp/cloudstack-updates.sql':
		ensure	=> file,
		owner	=> 'root',
		group	=> 'root',
		mode	=> '0644',
		source	=> 'puppet:///modules/bootstrap/cloudstack-updates.sql',
	}

	exec { 'mysqlupdates':
		command 	=> 'mysql -u root -ppassword cloud < /tmp/cloudstack-updates.sql',
		refreshonly	=> true,
		require		=> File['/tmp/cloudstack-updates.sql'],
		notify		=> Service['cloudstack-management'],
	}

	service { 'cloudstack-management':
		ensure	=> running,
		enable	=> true,
		hasrestart => true,
		hasstatus  => true,
		require	=> Package['cloudstack-management.x86_64'],
	}

	exec { 'install-cloudmonkey':
		command		=> 'easy_install cloudmonkey',
		refreshonly	=> true,
		notify		=> Exec['cloudmonkey-admin'],
	}

	exec { 'cloudmonkey-admin':
		command		=> 'cloudmonkey set username admin',
		refreshonly	=> true,
		notify		=> Exec['cloudmonkey-password'],
	}

	exec { 'cloudmonkey-password':
		command		=> 'cloudmonkey set password password',
		refreshonly 	=> true,
		notify		=> Exec['cloudmonkey-sync'],
	}

	exec { 'cloudmonkey-sync':
		command		=> 'cloudmonkey sync',
		refreshonly	=> true,
		notify		=> Exec['install-template'],
	}

	exec { 'install-template':
		command	=> '/usr/share/cloudstack-common/scripts/storage/secondary/cloud-install-sys-tmplt -m /exports/secondary -u http://packages.shapeblue.com/systemvmtemplate/4.5/4.5.2/systemvm64template-4.5-xen.vhd.bz2 -h xenserver -F',
		# refreshonly => true,
		timeout	=> 3600,
	}
}
