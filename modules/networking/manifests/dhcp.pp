class networking::dhcp {

    include networking::iface

    networking::iface::ethernet { $default_if: }

    include dhcp::client

}
