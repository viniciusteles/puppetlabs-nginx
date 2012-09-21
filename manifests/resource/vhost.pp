# define: nginx::resource::vhost
#
# This definition creates a virtual host
#
# Parameters:
#   [*ensure*]           - Enables or disables the specified vhost (present|absent)
#   [*listen_ip*]        - Default IP Address for NGINX to listen with this vHost on. Defaults to all interfaces (*)
#   [*listen_port*]      - Default IP Port for NGINX to listen with this vHost on. Defaults to TCP 80
#   [*ipv6_enable*]      - BOOL value to enable/disable IPv6 support (false|true). Module will check to see if IPv6
#                          support exists on your system before enabling.
#   [*ipv6_listen_ip*]   - Default IPv6 Address for NGINX to listen with this vHost on. Defaults to all interfaces (::)
#   [*ipv6_listen_port*] - Default IPv6 Port for NGINX to listen with this vHost on. Defaults to TCP 80
#   [*index_files*]      - Default index files for NGINX to read when traversing a directory
#   [*proxy*]            - Proxy server(s) for the root location to connect to.  Accepts a single value, can be used in
#                          conjunction with nginx::resource::upstream
#   [*proxy_read_timeout*] - Override the default the proxy read timeout value of 90 seconds
#   [*ssl*]              - Indicates whether to setup SSL bindings for this vhost.
#   [*ssl_cert*]         - Pre-generated SSL Certificate file to reference for SSL Support. This is not generated by this module.
#   [*ssl_key*]          - Pre-generated SSL Key file to reference for SSL Support. This is not generated by this module.
#   [*www_root*]         - Specifies the location on disk for files to be read from. Cannot be set in conjunction with $proxy
#
# Actions:
#
# Requires:
#
# Sample Usage:
#  nginx::resource::vhost { 'test2.local':
#    ensure   => present,
#    www_root => '/var/www/nginx-default',
#    ssl      => 'true',
#    ssl_cert => '/tmp/server.crt',
#    ssl_key  => '/tmp/server.pem',
#  }
define nginx::resource::vhost(
  $ensure             = 'enable',
  $listen_ip          = '*',
  $listen_port        = '80',
  $server_name         = undef,
  $www_root           = undef
) {

  File {
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  file { "nginx-vhost-available-${name}":
    path      => "/etc/nginx/sites-available/${name}",
    content   => template("nginx/vhost.erb"),
    notify    => Service['nginx'],
  }

  file { "nginx-vhost-enabled-${name}":
    path    => "/etc/nginx/sites-enabled/${name}",
    target  => "/etc/nginx/sites-available/${name}",
    ensure  => link,
    require => File["nginx-vhost-available-${name}"],
    notify  => Service['nginx'],
  }
}
