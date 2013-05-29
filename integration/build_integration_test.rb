#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), "spec_helper.rb")
@@osfamily = "RedHat"
begin
  require '/usr/libexec/mcollective/mcollective/agent/integration.rb'
rescue Exception => e
  require '/usr/share/mcollective/plugins/mcollective/agent/integration.rb'
  @@osfamily = "Debian"
end

describe "release integration test" do
  before :all do
    @mco_version = "2.2.4-1"
    @mco_dir = File.join("/", "home", "vagrant", "marionette-collective")
    @build_dir = File.join(@mco_dir, "build")
    @agent_dir = File.join("/", "home", "vagrant", "mcollective-service-agent")
    @agent = MCollective::Test::RemoteAgentTest.new("integration").plugin
    
    if @@osfamily == "RedHat"
      @mco_common_package = File.join(@build_dir, "mcollective-common-#{@mco_version}.el6.noarch.rpm")
      @mco_package = File.join(@build_dir, "mcollective-#{@mco_version}.el6.noarch.rpm")
      @mco_client_package = File.join(@build_dir, "mcollective-client-#{@mco_version}.el6.noarch.rpm")
    elsif @@osfamily == "Debian"
      @mco_common_package = File.join(@build_dir, "mcollective-common_#{@mco_version}_all.deb")
      @mco_package = File.join(@build_dir, "mcollective_#{@mco_version}_all.deb")
      @mco_client_package = File.join(@build_dir, "mcollective-client_#{@mco_version}_all.deb")
    end
  end

  describe "build" do
    it "should successfuly build the packages" do
      result = false
      Dir.chdir @mco_dir do
        if @@osfamily == "RedHat"
          result = system("rake rpm")
        elsif @@osfamily == "Debian"
          result = system("rake deb")
        end
      end
      result.should == true
    end 

    it "should successfuly upgrade the mcollective packages" do
      result = false
      
      if @@osfamily == "RedHat"
        result = system("sudo rpm -U --replacefiles #{@mco_package} #{@mco_client_package} #{@mco_common_package}")
      elsif @@osfamily == "Debian"
        result = system("sudo dpkg -i #{@mco_package} #{@mco_client_package} #{@mco_common_package}")
      end

      result.should == true
    end

    it "should successfuly build a plugin package" do
      result = false
      Dir.chdir @agent_dir do
        result = system("mco plugin package")
      end

      result.should == true 
    end

    it "should successfuly install the built package" do
      result = false
      Dir.chdir @agent_dir do
        if @@osfamily == "RedHat"
          result = system("sudo rpm -i *.noarch.rpm")
        elsif @@osfamily == "Debian"
          result = system("sudo dpkg -i *.deb")
        end
      end

      result.should == true
    end
  end 

  describe "post install tests" do
    it "should get an rpc ping response from all 5 nodes" do
      result = JSON.parse(%x{mco rpc rpcutil ping -j})
      result.size.should == 5
    end 

    it "should get 6 responses from mco find" do
      result = %x{mco find}.split("\n")
      result.size.should == 5
    end 

    it "should correctly apply the facts filter" do
      result = JSON.parse(%x{mco rpc rpcutil ping -F fqdn=middleware.example.net -j})
      result.size.should == 1
    end 
    it "should correctly apply the class filter" do
      result = JSON.parse(%x{mco rpc rpcutil ping -C release -j})
      result.size.should == 4
    end

    it "should correctly apply the identity filter" do
      result = JSON.parse(%x{mco rpc rpcutil ping -I /node./ -j})
      result.size.should == 4
    end

    it "should correctly apply the compound filter" do
      result = JSON.parse(%x{mco rpc rpcutil ping -S "fqdn=/node(0|1)/ or !release" -j})
      result.size.should == 3
    end

    it "should correctly apply the compound filter with a data function" do
      result = JSON.parse(%x{mco rpc rpcutil ping -S "agent('integration').version=1" -j})
      result.size.should == 5
    end

    it "should be able to install a plugin (package) from the puppetlabs repo" do
      result = false
      if @@osfamily == "RedHat"
        result = system("sudo yum install -y mcollective-package-agent mcollective-package-client")
      elsif @@osfamily == "Debian"
        result = system("sudo apt-get install -y mcollective-package-agent mcollective-package-client")
      end

      result.should == true
      # Restart mcollective after installing the agent
      system("sudo service mcollective restart")
    end

    it "should be able to use the newly installed plugin" do
      result = false
      result = system("mco package status mcollective")
      result.should == true
    end

    it "should correctly apply allow action policy rules" do
      results = JSON.parse(%x{mco rpc actionpolicy_test allow -j})
      results.each do |result|
        result["data"]["message"].should == "allowed" 
      end
    end

    it "should correctly apply deny action policy rules" do
      results = JSON.parse(%x{mco rpc actionpolicy_test deny -j})
      results.each do |result|
        result["statuscode"].should == 1
        result["statusmsg"].should == "You are not authorized to call this agent or action." 
      end
    end
  end
end
