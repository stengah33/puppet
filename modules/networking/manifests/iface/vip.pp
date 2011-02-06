define networking::iface::vip (
    $address,
    $auto   = true,
    $desc   = false,
    $ensure = present
) {
    alias { $name:
        address   => $address,
        auto      => $auto,
        ensure    => $ensure,
    }

    if $ensure == "present" {
        require networking::iface::vip::tuning
        include networking::iface

        if $desc {
            option { "$name comment":
                iface  => $name,
                option => "#comment",
                value  => "$name is a vip for $desc",
            }
        }
    }
}

class networking::iface::vip::tuning {

    include sysctl

    sysctl::set {
       "net.ipv4.conf.default.arp_ignore":
            value => 1;
       "net.ipv4.conf.all.arp_ignore":
            value => 1;
       "net.ipv4.conf.default.arp_announce":
            value => 2;
       "net.ipv4.conf.all.arp_announce":
            value => 2;
    }

}
