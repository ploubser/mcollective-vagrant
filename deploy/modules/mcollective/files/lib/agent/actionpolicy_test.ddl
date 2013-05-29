metadata    :name           => "Actionpolicy Integration Agent",
            :description    => "Actionpolicy Agent used for integration testing",
            :author         => "P Loubser",
            :license        => "GPLv2",
            :version        => "1",
            :url            => "http://..../",
            :timeout        => 60

requires :mcollective => "2.2.1"

action "deny", :description => "Always denied during integration testing" do

    output :message,
           :description => "Message",
           :display_as  => "Message that was received",
           :default     => nil
end

action "allow", :description => "Always allow during integration testing" do

    output :message,
           :description => "Message",
           :display_as  => "Message that was received",
           :default     => nil
end
