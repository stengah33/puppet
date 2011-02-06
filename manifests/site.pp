import "nodes.pp"
import "modules.pp"
import "classes/*.pp"


filebucket { main: server => puppet }
filebucket { local: path => "/var/lib/puppet/clientbucket" }
File { backup => main }
Exec { path => "/bin:/sbin:/usr/bin:/usr/sbin" }


class main {
}
