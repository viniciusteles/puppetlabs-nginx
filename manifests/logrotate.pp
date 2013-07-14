define nginx::logrotate($log_rotate_extension) {
  file { "/etc/logrotate.d/nginx":
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('nginx/logrotate.erb'),
  }
}
