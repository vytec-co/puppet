class nginx($version = "1.0.0"){
$packagename = "nginx"
$port = "9000"
notify{" class vars :: $version $port $::osfamily ":}
package{"$packagename":
  ensure => installed,
  before => File["/etc/nginx/server.xml"]
}
file{"/var/www/html/index.nginx-debian.html":
  ensure => file,
  content => inline_template("hi nginx <%= @fqdn %>"),
  require => Package["nginx"],
  notify => Service["nginx"]
}
file{"/etc/nginx/nginx.conf":
  ensure => file,
  source => "puppet:///modules/nginx/nginx.conf",
  require => Package["nginx"],
  notify => Service["nginx"]
}
file{"/etc/nginx/server.xml":
  ensure => file,
  content => template("nginx/server.xml.erb"),
  require => Package["nginx"],
  notify => Service["nginx"]
}
service{"$packagename":
ensure => true,
subscribe => File["/etc/nginx/server.xml"]
}

}
