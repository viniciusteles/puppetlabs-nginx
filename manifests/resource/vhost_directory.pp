define nginx::resource::vhost_directory(
  $ensure             = 'enable',
  $listen_ip          = '*',
  $listen_port        = '80',
  $server_names       = undef,
  $www_root           = undef,
) {

  if type($server_names) == 'string' {
    $server_names_real = [$server_names]
  } else {
    $server_names_real = $server_names
  }

  File {
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  file { "nginx-vhost-available-${name}":
    path      => "/etc/nginx/sites-available/${name}",
    content   => template("nginx/vhost/vhost_directory.erb"),
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
