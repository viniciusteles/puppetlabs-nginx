define nginx::logrotate {
  file { "/etc/logrotate.d/nginx":
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('nginx/logrotate.erb'),
  }
}
