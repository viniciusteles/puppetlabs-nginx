# Class: nginx::config
#
# This module manages NGINX bootstrap and configuration
#
# Parameters:
#
# There are no default parameters for this class.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# This class file is not called directly
class nginx::config(
  $worker_processes,
  $logrotate_extension,
) inherits nginx::params {

  if $worker_processes != 'undef' {
    $worker_processes_real = $worker_processes
  } else {
    $worker_processes_real = $nx_worker_processes
  }

  if $logrotate_extension != 'undef' {
    $logrotate_extension_real = $logrotate_extension
  } else {
    $logrotate_extension_real = ''
  }

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { "${nginx::params::nx_conf_dir}":
    ensure => directory,
  }

  file { "${nginx::params::nx_conf_dir}/conf.d":
    ensure => directory,
  }

  file { "${nginx::params::nx_conf_dir}/sites-available":
    ensure => directory,
  }

  file { "${nginx::params::nx_conf_dir}/sites-enabled":
    ensure => directory,
  }

  file { "${nginx::config::nx_run_dir}":
    ensure => directory,
  }

  file { "${nginx::config::nx_client_body_temp_path}":
    ensure => directory,
    owner  => $nginx::params::nx_daemon_user,
  }

  file {"${nginx::config::nx_proxy_temp_path}":
    ensure => directory,
    owner  => $nginx::params::nx_daemon_user,
  }

  file { '/etc/nginx/sites-enabled/default':
    ensure => absent,
  }

  file { "${nginx::params::nx_conf_dir}/conf.d/default.conf":
    ensure => absent,
  }

  file { "${nginx::params::nx_conf_dir}/nginx.conf":
    ensure  => file,
    content => template('nginx/conf.d/nginx.conf.erb'),
  }

  file { "${nginx::params::nx_conf_dir}/conf.d/proxy.conf":
    ensure  => file,
    content => template('nginx/conf.d/proxy.conf.erb'),
  }

  file { "${nginx::config::nx_temp_dir}/nginx.d":
    ensure  => directory,
    purge   => true,
    recurse => true,
  }

  nginx::logrotate { 'nginx':
    logrotate_extension => $logrotate_extension_real,
  } 
}
