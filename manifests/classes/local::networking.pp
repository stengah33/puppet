class local::networking {

    include networking::iface

    if ($networking_bridged != false) {
        if ($networking_bridged != []) {
            networking::iface::ethernet { $networking_bridged:
                ensure  => absent,
                require => Package["bridge-utils"],
            }

            networking::iface::bridge { "br0":
                ports   => join(" ", $networking_bridged),
                address => $ipaddress,
                gateway => $networking_gateway,
            }
        }
    }
    else {
        networking::iface::ethernet { $default_if:
            address => $ipaddress,
        }
    }

}
