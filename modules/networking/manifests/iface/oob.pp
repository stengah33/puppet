define networking::iface::oob (
    $address,
    $netmask,
    $broadcast = false,
    $gateway,
    $auto      = true,
    $up        = true,
    $down      = false,
    $ensure    = present
) {

    ethernet { $name:
        address   => $address,
        netmask   => $netmask,
        broadcast => $broadcast,
        up        => false,
        down      => $down,
        auto      => $auto,
        ensure    => $ensure,
    }

    include networking::iface

    if ($ensure == "present") {
        option {
            "$name up rule":
                option  => "up",
                value   => "ip rule add from $address lookup oob";
            "$name up route":
                option  => "up",
                value   => "ip route add default via $gateway table oob";
            "$name down rule":
                option  => "down",
                value   => "ip rule del from $address lookup oob";
            "$name down route":
                option  => "down",
                value   => "ip route del default via $gateway table oob";
        }

        Networking::Iface::Option[
            "$name up rule",
            "$name up route",
            "$name down rule",
            "$name down route"
        ] {
            iface   => $name,
            multi   => true,
            require => Ethernet[$name],
            before  => Up["oob $name up"],
        }

        networking::rtable { "oob": number => 101 }

        up { "oob $name up":
            iface   => $name,
            really  => $down ? { true => false, false => $up},
            require => Rtable["oob"],
        }
    }
    else {
        delete { "$name delete":
            iface => $name,
        }
    }

}
