define networking::iface::alias (
    $address   = false,
    $netmask   = false,
    $broadcast = false,
    $auto      = true,
    $up        = true,
    $down      = false,
    $ensure    = present
) {

    ethernet { $name:
        ensure    => $ensure,
        auto      => $auto,
        up        => $up,
        down      => $down,
    }

    if $ensure == "present" {

        if !$address {
            error("present alias must have address")
        }

        $_netmask = $netmask ? {
            false   => "255.255.255.255",
            default => $netmask,
        }

        $_broadcast = $broadcast ? {
            false   => ipaddr_broadcast($address, $_netmask),
            default => $broadcast,
        }

        Ethernet[$name] {
            address   => $address,
            netmask   => $_netmask,
            broadcast => $_broadcast,
        }
    }

}
