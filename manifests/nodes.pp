node basenode {
	include augeas
	include apt
	include os::ubuntu-lucid
	include ssh
	include sudo::base
	
}
node puppetmaster inherits basenode {
}

node "holborn" inherits puppetmaster {
}
	
node "pimlico" inherits basenode {
#	Desktop
	include desktop	
	include sourcecontrol
	include apache

	include mysql::server::medium	
	include mysql::client
	package { "mytop":
		ensure => installed,
	}
	
	networking::iface::ethernet { "eth0":
		address => "192.168.0.100",
		netmask => "255.255.255.0",
		gateway => "192.168.0.1",
	}
	$mysql_serverid = "10050"

	package { "network-manager":
		ensure => absent,
	}
}


node "servera" inherits basenode{
	include sourcecontrol
	include apache
	include memcached::server
	include memcached::php
	networking::iface::ethernet { "eth0":
                address => "192.168.0.10",
                netmask => "255.255.255.0",
                gateway => "192.168.0.1",
        }
	package { "pound":
                ensure => installed,
        }

	$gl_username = "glusterfs"
	$gl_password = "FlusteredBarmaid"
	
	glusterfs::server::config { gluster:
		username => $gl_username,
		password => $gl_password
	}

	glusterfs::client::config { gluster:
		servers => [ "servera", "serverb"],
		username => $gl_username,
                password => $gl_password
	}	
}


node "serverb" inherits basenode{
	include sourcecontrol
	include apache
	include memcached::server
	include memcached::php

	networking::iface::ethernet { "eth0":
                address => "192.168.0.11",
                netmask => "255.255.255.0",
                gateway => "192.168.0.1",
        }
	package { "pound":
                ensure => installed,
        }
	
	$gl_username = "glusterfs"
	$gl_password = "FlusteredBarmaid"
	
	glusterfs::server::config { gluster:
		username => $gl_username,
		password => $gl_password
	}

	glusterfs::client::config { gluster:
		servers => [ "servera", "serverb"],
		username => $gl_username,
                password => $gl_password
	}	
}
node "serverc" inherits basenode{
	include mysql::server::medium
        include mysql::client
	package { "mytop":
		ensure => installed
	}
	networking::iface::ethernet { "eth0":
                address => "192.168.0.12",
                netmask => "255.255.255.0",
                gateway => "192.168.0.1",
        }

}
node "serverd" inherits basenode{
	include mysql::server::medium
        include mysql::client
	package { "mytop":
		ensure => installed
	}
	networking::iface::ethernet { "eth0":
                address => "192.168.0.13",
                netmask => "255.255.255.0",
                gateway => "192.168.0.1",
        }

}

