class networking {

    package {
        [
            "netbase",
            "ethtool",
            "iproute",
            "iputils-ping",
            "traceroute"
        ]:
            ensure => latest,
    }

}
