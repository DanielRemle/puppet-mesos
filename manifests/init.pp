# == Class: mesos
#
# This module manages mesos installation
#
# === Examples
#
#      class{ 'mesos::master': }
#  or
#      class{ 'mesos:slave': }
#
#
# === Authors
#
# Tomas Barton <barton.tomas@gmail.com>
#
# === Copyright
#
# Copyright 2013-2014 Tomas Barton
#
class mesos(
  $ensure         = 'present',
  $version        = undef, # if version is not defined, ensure will be used
  $log_dir        = '/var/log/mesos', # master and slave creates separate logs automatically # TODO: currently not used
  $conf_dir       = '/etc/mesos',
  $zookeeper      = '', # e.g. zk://localhost:2181/mesos # if "zk" is empty, master value is used
  $master         = '127.0.0.1',
  $master_port    = 5050,
  $owner          = 'root',
  $group          = 'root',
  $listen_address = undef, # could be a fact like $::ipaddress or explicit ip address
  $repo           = undef,
  $env_var        = {},
  $ulimit         = 8192,
) {
  validate_hash($env_var)

  $mesos_ensure = $version ? {
    undef    => $ensure,
    default  => $version,
  }

  package {'mesos':
    ensure  => $mesos_ensure,
  }

  class {'mesos::config':
    log_dir   => $log_dir,
    conf_dir  => $conf_dir,
    owner     => $owner,
    group     => $group,
    zookeeper => $zookeeper,
    env_var   => $env_var,
    ulimit    => $ulimit,
    require   => Package['mesos']
  }

}
