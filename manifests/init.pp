# Class: nginx
#
# This module manages NGINX.
#
# Parameters:
#
# There are no default parameters for this class. All module parameters are managed
# via the nginx::params class
#
# Actions:
#
# Requires:
#  puppetlabs-stdlib - https://github.com/puppetlabs/puppetlabs-stdlib
#
#  Packaged NGINX
#    - RHEL: EPEL or custom package
#    - Debian/Ubuntu: Default Install or custom package
#    - SuSE: Default Install or custom package
#
#  stdlib
#    - puppetlabs-stdlib module >= 0.1.6
#    - plugin sync enabled to obtain the anchor type
#
# Sample Usage:
#
# The module works with sensible defaults:
#
# node default {
#   include nginx
# }
class nginx(
  $worker_processes    = 'undef',
  $logrotate_extension = 'undef',
) {

  class { 'stdlib': }

  class { 'nginx::package':
    notify => Class['nginx::service'],
  }

  class { 'nginx::config':
    worker_processes    => $worker_processes,
    logrotate_extension => $logrotate_extension,
    require => Class['nginx::package'],
    notify  => Class['nginx::service'],
  }

  class { 'nginx::service': }

  # Allow the end user to establish relationships to the "main" class
  # and preserve the relationship to the implementation classes through
  # a transitive relationship to the composite class.
  anchor{ 'nginx::begin':
    before => Class['nginx::package'],
    notify => Class['nginx::service'],
  }
  anchor { 'nginx::end':
    require => Class['nginx::service'],
  }
}
