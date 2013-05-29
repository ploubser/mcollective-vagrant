class mcollective::install {

  if $osfamily == "RedHat"{
    package{["gnuplot", "rubygem-redis", "rubygem-formatr", "rubygem-rake",
           "rubygem-rspec", "rubygem-mocha", "rubygem-mcollective-test"]:
      ensure => latest
    }

    package{["mcollective-common", "mcollective", "mcollective-client"]:
      ensure => "$mco_version.el6",
    }
  }elsif $osfamily == "Debian"{

    package{"gnuplot":
        ensure => latest
    } ->

    package{"mocha" :
      ensure => "0.10.4",
      provider => "gem",
    }

    package{"rspec-core":
      ensure => "2.12",
      provider => "gem",
    } ->

    package{"rspec-expectations":
      ensure => "2.12.0",
      provider => "gem",
    } ->

    package{"rspec-mocks":
      ensure => "2.12.0",
      provider => "gem",
    } ->

    package{"rspec" :
     ensure => "2.12.0",
     provider => "gem",
    }

    package{["redis", "formatr","mcollective-test", "stomp", "rdoc", "rake"]:
      ensure => installed,
      provider => "gem",
    }
   
    package{"mcollective-common":
      ensure => $mco_version,
      require => Package["stomp"],
    } ->
    package{"mcollective":
      ensure => $mco_version,
      require => Package["stomp"],
    } ->
    package{"mcollective-client":
      ensure => $mco_version,
      require => Package["stomp"],
    }
  }
}
