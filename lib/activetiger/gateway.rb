module ActiveTiger
  class Gateway
    TIGER_GATEWAY_URL = "https://secure.tigergateway.net/api/transact.php"

    def initialize(params = {})
      if defined?(RAILS_ENV) && defined?(RAILS_ROOT)
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

