require File.dirname(__FILE__) + '/../spec_helper'

describe ActiveTiger::Configuration do
  it "loads the yaml configuration for the given environment" do
    file_mock = mock("Config file")
    File.should_receive(:read).with("foo/config/activetiger/test.yml").and_return(file_mock)
    YAML.should_receive(:load).with(file_mock)

    with_constants :RAILS_ENV => "test", :RAILS_ROOT => "foo" do
      ActiveTiger::Configuration.new
    end
  end

  describe "with a loaded configuration" do
    before(:each) do
      yml = <<-YML
username: user
password: pass
      YML

      File.should_receive(:read).with("foo/config/activetiger/test.yml").and_return(yml)

      with_constants :RAILS_ENV => "test", :RAILS_ROOT => "foo" do
        @config = ActiveTiger::Configuration.new
      end
    end

    it "gives the correct username" do
      @config.username.should == "user"
    end

    it "gives the correct password" do
      @config.password.should == "pass"
    end
  end
end

