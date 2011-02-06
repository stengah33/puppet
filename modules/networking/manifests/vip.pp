define networking::vip () {

    include networking::iface

    $address = $name ? {
       "web"              => "192.168.100.2",
       "database"              => "192.168.90.2",
        default                        => fail("unknown vip name"),
    }

    $octet = ipaddr_lastoctet($address)
    $iface = "lo:$octet"

    networking::iface::vip { $iface:
        address => $address,
        desc    => $name,
    }

}
