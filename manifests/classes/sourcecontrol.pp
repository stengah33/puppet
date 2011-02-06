class sourcecontrol {
	package {"subversion":
		ensure => installed
	}
	package {"git-core":
		ensure => installed
	}
	package {"bzr":
		ensure => installed
	}
	package {"bzrtools":
		ensure => installed
	}
}
