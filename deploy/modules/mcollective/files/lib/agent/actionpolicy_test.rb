module MCollective
  module Agent
    class Actionpolicy_test<RPC::Agent
      action "deny" do
        reply[:message] = "denied"
      end

      action "allow" do
        reply[:message] = "allowed"
      end
    end
  end
end
