define networking::iface::vlan (
    $vlan      = false,
    $iface     = false,
    $address   = false,
    $netmask   = false,
    $broadcast = false,
    $gateway   = false,
    $auto      = true,
    $up        = true,
    $down      = false,
    $ensure    = present
) {
    $_iface = $iface ? {
        false   => regsubst($name, '([^.]+)\..*', '\1'), # '
        default => $iface,
    }

    $_vlan = $vlan ? {
        false   => regsubst($name, '[^.]+\.(.+)', '\1'), # '
        default => $vlan,
    }

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

    if $ensure == "present" {
        include networking::iface::vlan::packages
        include networking::iface

        Networking::Iface::Option {
            iface   => $name,
            require => Ethernet[$name],
            before  => Up["vlan $_vlan up"],
        }

        option {
            "$name pre-up":
                option  => "pre-up",
                value   => "vconfig add $_iface $_vlan";
            "$name pre-down":
                option  => "pre-down",
                value   => "vconfig rem $name";
        }

        up { "vlan $_vlan up":
            iface   => $name,
            really  => $down ? { true => false, false => $up },
            require => Package["vlan"],
        }
    }
}

class networking::iface::vlan::packages {

    package { "vlan":
        ensure => latest,
    }

}
