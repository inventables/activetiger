module ActiveTiger
  # =Overview
  # The Gateway class alows you to interact with Tiger Payment Processing.
  #
  # First, we instantiate a gateway. If you're using ActiveTiger in a
  # rails application, there's no need to provide username/password
  # credentials on instantiation. ActiveTiger will look for a configuration
  # file at:
  #   config/activetiger/#{Rails.env}.yml 
  #
  # =Creating a Gateway
  #
  # First we instantiate a gateway in a rails application:
  #   # create a gateway from a rails app
  #   gateway = ActiveTiger::Gateway.new
  #
  #   # create a gateway in any ruby application
  #   gateway = ActiveTiger::Gateway.new(:username => "demo", :password => "password")
  #
  # =Gateway Actions
  #  
  # Once a Gateway is created, we can take many actions. Let's look at each
  # of these.
  #
  # ==Sale
  #
  # Charge a card immediately. You must provide a ccnumber, ccexp and amount
  # as a minimum. 
  #
  #  response = gateway.sale(
  #   :ccnumber => "4111111111111111", 
  #   :ccexp => "1010", 
  #   :amount => "1.00"
  #  )
  #
  #  puts "Success!" if response.approved?
  #
  # ==Authorize
  #
  # Authorize the card to be captured in the future. Again, provide a ccnumber,
  # ccexp and amount at a minumum. Store the resulting transaction_id to capture
  # at a later time.
  #
  #  response = gateway.authorize(
  #   :ccnumber => "4111111111111111", 
  #   :ccexp => "1010", 
  #   :amount => "1.00"
  #  )
  #
  #  # store transaction_id for capture later
  #  transaction_id = response.transaction_id
  #
  # ==Capture
  #
  # Capture a previously authorized transaction. All you need is the transactionid.
  #
  #  response = gateway.capture(:transactionid => my_transaction_id)
  #  puts "Success!" if response.approved?
  #
  # ==Credit
  #
  # Credit the card with some amount. Provide the ccnumber, ccexp and amount.
  #
  #  response = gateway.credit(
  #   :ccnumber => "4111111111111111", 
  #   :ccexp => "1010", 
  #   :amount => "1.00"
  #  )
  #
  #  puts "you just gave them a buck" if response.approved?
  #
  # ==Void
  #
  # Void an uncaptured transaction. Just provide the transactionid.
  #
  #  response = gateway.void(:transactionid => my_transaction_id)
  #  puts "voided ftw" if response.approved?
  #
  # ==Refund
  #
  # Refund a transaction that has already been sold or captured. Just give it
  # that transactionid.
  #
  #  response = gateway.refund(:transactionid => my_transaction_id)
  #  puts "refund-city" if response.approved?
  #
  # ==Update
  #
  # Update an uncaptured transaction. Just provide the transactionid.
  #
  #  response = gateway.update(:transactionid => my_transaction_id)
  #  puts "updated" if response.approved?
  #
  # =Responses
  #
  # For more info on how to deal with responses from the Gateway, check out
  # the Response class.
  class Gateway
    TIGER_GATEWAY_URL = "https://secure.tigergateway.net/api/transact.php"

    def initialize(params = {})
      if defined?(Rails.env) && defined?(Rails.root)
        config = ActiveTiger::Configuration.new
        @username = config.username
        @password = config.password
      else
        @username = params[:username]
        @password = params[:password]
      end
    end

    ["sale", "credit", "capture", "void", "refund", "update"].each do |operation|
      define_method(operation) do |params|
        params.merge! :type => operation
        make_request(params)
      end
    end

    def authorize(params)
      params.merge! :type => "auth"
      make_request(params)
    end

    private

    def make_request(params)
      params.merge! :username => @username, :password => @password
      response_string = tiger_gateway.post(params)
      ActiveTiger::Response.build_from_string(response_string)
    end

    def tiger_gateway
      @tiger_gateway ||= RestClient::Resource.new(TIGER_GATEWAY_URL)
    end
  end
end

