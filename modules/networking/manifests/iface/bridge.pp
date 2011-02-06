define networking::iface::bridge (
    $ports     = "eth0 eth1",
    $stp       = true,
    $address   = false,
    $netmask   = false,
    $broadcast = false,
    $gateway   = false,
    $auto      = true,
    $up        = true,
    $down      = false,
    $ensure    = present
) {

    ethernet { $name:
        address   => $address,
        netmask   => $netmask,
        broadcast => $broadcast,
        gateway   => $gateway,
        auto      => $auto,
        up        => false,
        down      => $down,
        ensure    => $ensure,
    }

    if ($ensure == "present") {

        include networking::iface

        option { "$name bridge_ports":
            iface   => $name,
            option  => "bridge_ports",
            value   => $ports,
            require => Ethernet[$name],
        }

        if ($stp) {
            option {
                "$name bridge_stp":
                    iface  => $name,
                    option => "bridge_stp",
                    value  => "on";
                "$name bridge_bridgeprio":
                    iface  => $name,
                    option => "bridge_bridgeprio",
                    value  => "60000";
            }

            Option[
                "$name bridge_stp",
                "$name bridge_bridgeprio"
            ] {
                require => Option["$name bridge_ports"],
                before  => Up["bridge $name up"],
            }
        }

        package { "bridge-utils":
            ensure => latest,
            before => Up["bridge $name up"],
        }

        up { "bridge $name up":
            iface  => $name,
            really => $down ? { true => false, false => $up },
        }
    }
    else {
        exec { "bridge $name delete":
            command     => "/usr/sbin/brctl delbr $name",
            refreshonly => true,
            subscribe   => Networking::Iface::Delete["$name delete"],
        }
    }

}
