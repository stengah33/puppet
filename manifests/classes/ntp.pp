#ntp.pp

class ntp {
	package { "ntp":
		ensure => latest,
	}

	package {"ntpdate":
		ensure => latest,
	}

	service { "ntpd":
		ensure => running,
	}

}

