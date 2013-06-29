# == Class: nodejs
#
# Full description of class nodejs here.
#
#   Explanation of what this parameter affects and what it defaults to.
# === Parameters
#
# Document parameters here.
#
# [*version*]
#   Specify the exact nodejs version required e.g. 0.10.4
#
# === Examples
#
#  class { nodejs:
#    version => '0.10.4'
#  }
#
# === Authors
#
# Thom Seddon <thom@nightworld.com>
#
# === Copyright
#
# Copyright 2013-present Thom Seddon
#
class nodejs (
  $version,
  $path = '/bin:/sbin:/usr/bin:/usr/sbin'
) {
  $namestr = "node-v${version}-linux-x64"
  $url = "http://nodejs.org/dist/v${version}/${namestr}.tar.gz"

  exec { "Retrieve ${url}":
    command => "wget ${url} -O /tmp/${namestr}.tar.gz",
    creates => "/tmp/${namestr}.tar.gz",
    path => $path
  }

  exec { "Inflate":
    command => "tar -zxf /tmp/${namestr}.tar.gz -C /tmp",
    creates => "/tmp/${namestr}",
    require => Exec["Retrieve ${url}"],
    notify => Exec["Installing node v${version}"],
    path => $path
  }

  exec { "Installing node v${version}":
    command => "cp -rf /tmp/${namestr}/bin/node /usr/bin/node && cp -rf /tmp/${namestr}/lib/node_modules /usr/lib/",
    require => Exec["Inflate"],
    refreshonly => true,
    path => $path
  }
  file { '/usr/bin/npm':
    owner => 'root',
    group => 'root',
    ensure => 'link',
    target => '../lib/node_modules/npm/bin/npm-cli.js',
    require => Exec["Installing node v${version}"]
  }

}
