define networking::rtable (
    $ensure = present,
    $number
) {

    include networking

    if $ensure == "present" {
        exec { "route table add $name":
            command => "/bin/echo '$number $name' >> /etc/iproute2/rt_tables",
            unless  => "/bin/grep -qF '$number $name' /etc/iproute2/rt_tables",
            require => Package["iproute"],
        }
    }
    else {
        exec { "route table del $name":
            command => "/bin/sed -i '/^$number $name$/d' /etc/iproute2/rt_tables",
            onlyif  => "/bin/grep -qF '$number $name' /etc/iproute2/rt_tables",
            require => Package["iproute"],
        }
    }

}
