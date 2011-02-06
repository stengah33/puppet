$networking_routers = [ "192.168.0.1",]
$networking_gateway = iprandchoice($networking_routers)
$networking_network = "192.168.0.0"
$networking_netmask = "255.255.255.0"
$networking_bridged = false
