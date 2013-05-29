class roles::node {
    class{"repos": } ->
    class{"puppet": } ->
#    class{"nagios": } ->
    class{"mcollective": } ->
    class{"motd": } ->
    class{"release" :} ->
    Class[$name]
}
