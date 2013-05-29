class mcollective {
  class{"mcollective::install": } ->
  class{"mcollective::config": } ~>
  class{"mcollective::service": } ->
  Class[$name]

  Class["mcollective::install"] ~> Class["mcollective::service"]
}
