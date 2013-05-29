class mcollective::config {
   
   if $osfamily == "Debian"{
     $mcpath = "/usr/share/mcollective/plugins/mcollective/"
   }else{
     $mcpath = "/usr/libexec/mcollective/mcollective"
   }

   file{"/etc/mcollective/server.cfg":
      owner => root,
      group => root,
      mode  => 0500,
      content => template("mcollective/server.cfg.erb")
   }

   file{"/etc/mcollective/plugin.d":
      owner  => root,
      group  => root,
      mode   => 0744,
      ensure => directory,
   }

   file{"/etc/mcollective/client.cfg":
      owner => root,
      group => root,
      mode  => 0444,
      content => template("mcollective/client.cfg.erb")
   }

   file{"/etc/mcollective/inventory.mc":
      owner => root,
      group => root,
      mode  => 0444,
      source => "puppet:///modules/mcollective/inventory.mc"
   }

   file{$mcpath:
      owner => root,
      group => root,
      recurse => true,
      source => "puppet:///modules/mcollective/lib"
   }

   file{"/etc/mcollective/facts.yaml":
      content => inline_template("<%= Hash[scope.to_hash.reject { |k,v| k.to_s =~ /(uptime|timestamp|memory|free|swap)/ }.sort].to_yaml %>"),
      owner => root,
      group => root,
      mode => 0444,
   }

  file{"/etc/mcollective/policies":
      ensure => "directory",
      owner  => root,
      group  => root,
      mode   => 0444,
  } ->

  file{"/etc/mcollective/policies/actionpolicy_test.policy":
      owner  => root,
      group  => root,
      mode   => 0444,
      source => "puppet:///modules/mcollective/actionpolicy_test.policy", 
  }
}
