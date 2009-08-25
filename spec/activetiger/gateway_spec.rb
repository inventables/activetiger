require File.dirname(__FILE__) + '/../spec_helper'

describe ActiveTiger::Gateway do
  before(:each) do
    @default_response = "response=1&responsetext=SUCCESS&authcode=123456&transactionid=1042256997&avsresponse=&cvvresponse=&orderid=&type=sale&response_code=100"
    @mock_tiger_gateway = mock('Tiger ActiveTigers')
    RestClient::Resource.stub!(:new).with("https://secure.tigergateway.net/api/transact.php").and_return(@mock_tiger_gateway)
  end

  it "creates a payment response" do
    @mock_tiger_gateway.stub!(:post).with(
      :username => "drew",
      :password => "foo",
      :type => "sale",
      :ccnumber => "4111111111111111",
      :ccexp => "1010",
      :amount => "1.00"
    ).and_return(@default_response)

    ActiveTiger::Response.should_receive(:build_from_string).with(@default_response)

    gateway = ActiveTiger::Gateway.new(:username => "drew", :password => "foo")
    gateway.sale :ccnumber => "4111111111111111", :ccexp => "1010", :amount => "1.00"
  end

  context "if RAILS_ROOT and RAILS_ENV are defined" do
    it "defaults to payment configuration values" do
      with_constants :RAILS_ROOT => "bar", :RAILS_ENV => "test" do
        config_mock = mock("ActiveTiger configuration")
        config_mock.should_receive(:username).and_return("drew")
        config_mock.should_receive(:password).and_return("pass")
        ActiveTiger::Configuration.should_receive(:new).and_return(config_mock)

        gateway = ActiveTiger::Gateway.new
      end
    end
  end

  context "if RAILS_ROOT or RAILS_ENV are not defined" do
    it "should not create an instance of the configuration class" do
      ActiveTiger::Configuration.should_not_receive(:new)
      gateway = ActiveTiger::Gateway.new
    end
  end

  describe "#sale" do
    it "posts a hash of arguments the payment gateway" do
      @mock_tiger_gateway.should_receive(:post).with(
        :username => "drew",
        :password => "foo",
        :type => "sale",
        :ccnumber => "4111111111111111",
        :ccexp => "1010",
        :amount => "1.00"
      ).and_return(@default_response)

      gateway = ActiveTiger::Gateway.new(:username => "drew", :password => "foo")
      gateway.sale :ccnumber => "4111111111111111", :ccexp => "1010", :amount => "1.00"
    end
  end

  describe "#authorize" do
    it "posts a hash of arguments the payment gateway" do
      @mock_tiger_gateway.should_receive(:post).with(
        :username => "drew",
        :password => "foo",
        :type => "auth",
        :ccnumber => "4111111111111111",
        :ccexp => "1010",
        :amount => "1.00"
      ).and_return(@default_response)

      gateway = ActiveTiger::Gateway.new(:username => "drew", :password => "foo")
      gateway.authorize :ccnumber => "4111111111111111", :ccexp => "1010", :amount => "1.00"
    end
  end

  describe "#credit" do
    it "posts a hash of arguments the payment gateway" do
      @mock_tiger_gateway.should_receive(:post).with(
        :username => "drew",
        :password => "foo",
        :type => "credit",
        :ccnumber => "4111111111111111",
        :ccexp => "1010",
        :amount => "1.00"
      ).and_return(@default_response)

      gateway = ActiveTiger::Gateway.new(:username => "drew", :password => "foo")
      gateway.credit :ccnumber => "4111111111111111", :ccexp => "1010", :amount => "1.00"
    end
  end

  describe "#capture" do
    it "posts a hash of arguments the payment gateway" do
      @mock_tiger_gateway.should_receive(:post).with(
        :username => "drew",
        :password => "foo",
        :type => "capture",
        :transactionid => "12345",
        :amount => "1.00"
      ).and_return(@default_response)

      gateway = ActiveTiger::Gateway.new(:username => "drew", :password => "foo")
      gateway.capture :transactionid => "12345", :amount => "1.00"
    end
  end

  describe "#void" do
    it "posts a hash of arguments the payment gateway" do
      @mock_tiger_gateway.should_receive(:post).with(
        :username => "drew",
        :password => "foo",
        :type => "void",
        :transactionid => "12345"
      ).and_return(@default_response)

      gateway = ActiveTiger::Gateway.new(:username => "drew", :password => "foo")
      gateway.void :transactionid => "12345"
    end
  end

  describe "#refund" do
    it "posts a hash of arguments the payment gateway" do
      @mock_tiger_gateway.should_receive(:post).with(
        :username => "drew",
        :password => "foo",
        :type => "refund",
        :transactionid => "12345",
        :amount => "1.00"
      ).and_return(@default_response)

      gateway = ActiveTiger::Gateway.new(:username => "drew", :password => "foo")
      gateway.refund :transactionid => "12345", :amount => "1.00"
    end
  end

  describe "#update" do
    it "posts a hash of arguments the payment gateway" do
      @mock_tiger_gateway.should_receive(:post).with(
        :username => "drew",
        :password => "foo",
        :type => "update",
        :transactionid => "12345"
      ).and_return(@default_response)

      gateway = ActiveTiger::Gateway.new(:username => "drew", :password => "foo")
      gateway.update :transactionid => "12345"
    end
  end
end

