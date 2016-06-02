class bootstrap::postgresql{

	exec{'module-install':
		command		=> "puppet module install puppetlabs-postgresql",
		refreshonly	=> true,
		before		=>
	}

}
