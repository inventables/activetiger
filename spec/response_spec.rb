require File.dirname(__FILE__) + '/spec_helper'

describe ActiveTiger::Response do
  describe "#build_from_string" do
    it "builds a response object from a url params string" do
      ActiveTiger::Response.should_receive(:new).with(
        :response => "1", 
        :responsetext => "SUCCESS",
        :authcode => nil,
        :transactionid => "1042369612",
        :avsresponse => nil,
        :cvvresponse => nil,
        :orderid => nil,
        :type => "refund",
        :response_code => "100"
      )

      ActiveTiger::Response.build_from_string(
        "response=1&responsetext=SUCCESS&authcode=&transactionid=1042369612&avsresponse=&cvvresponse=&orderid=&type=refund&response_code=100"
      )
    end
  end

  describe "#approved?" do
    it "returns true if approved" do
      response = ActiveTiger::Response.new(:response => "1")
      response.should be_approved
    end

    it "returns false if not approved" do
      response = ActiveTiger::Response.new(:response => "2")
      response.should_not be_approved
    end
  end

  describe "#declined?" do
    it "returns true if declined" do
      response = ActiveTiger::Response.new(:response => "2")
      response.should be_declined
    end

    it "returns false if not declined" do
      response = ActiveTiger::Response.new(:response => "1")
      response.should_not be_declined
    end
  end

  describe "#has_errors?" do
    it "returns true if declined" do
      response = ActiveTiger::Response.new(:response => "3")
      response.should have_errors
    end

    it "returns false if not declined" do
      response = ActiveTiger::Response.new(:response => "1")
      response.should_not have_errors
    end
  end

  describe "#transaction_id" do
    it "returns the transaction_id" do
      response = ActiveTiger::Response.new(:transactionid => "12345")
      response.transaction_id.should == "12345" 
    end
  end

  describe "#response_code_message" do
    it "returns the response_code_message associated with the response code" do
      response = ActiveTiger::Response.new(:response_code => "100")
      response.response_code_message.should == "Transaction was Approved"
    end

    it "returns the default response_code_message for an unknow response code" do
      response = ActiveTiger::Response.new(:response_code => "42")
      response.response_code_message.should == ActiveTiger::Response::DEFAULT_MESSAGE
    end
  end

  describe "#response_code" do
    it "returns the response_code" do
      response = ActiveTiger::Response.new(:response_code => "100")
      response.response_code.should == "100"
    end
  end

  describe "#message" do
    it "returns the response text" do
      response = ActiveTiger::Response.new(:responsetext => "Sample Text")
      response.message.should == "Sample Text"
    end
  end
end

