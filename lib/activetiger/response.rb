module ActiveTiger
  class Response
    RESPONSE = {
      :approved => "1",
      :declined => "2",
      :errors => "3"
    }
    DEFAULT_MESSAGE = "No Message Provided"
    RESPONSE_CODE_MESSAGES = {
      "100" => "Transaction was Approved",
      "200" => "Transaction was Declined by Processor",
      "200" => "Do Not Honor",
      "201" => "Insufficient Funds",
      "202" => "Over Limit",
      "203" => "Transaction not allowed",
      "220" => "Incorrect Payment Data",
      "221" => "No Such card Issuer",
      "222" => "No Card Number on file with Issuer",
      "223" => "Expired Card",
      "224" => "Invalid Expiration Date",
      "225" => "Invalid Security Code",
      "240" => "Call Issuer for Further Information",
      "250" => "Pick Up Card",
      "251" => "Lost Card",
      "252" => "Stolen Card",
      "253" => "Fraudulant Card",
      "260" => "Declined with further Instructions Available (see response text)",
      "261" => "Declined - Stop All Recurring Payments",
      "262" => "Declined - Stop this Recurring Program",
      "263" => "Declined - Update Cardholder Data Available",
      "264" => "Declined - Retry in a few days",
      "300" => "Transaction was Rejected by Gateway",
      "400" => "Transaction Error Returned by Processor",
      "410" => "Invalid Merchant Configuration",
      "411" => "Merchant Account is Inactive",
      "420" => "Communication Error",
      "421" => "Communication Error with Issuer",
      "430" => "Duplicate Transaction at Processor",
      "440" => "Processor Format Error",
      "441" => "Invalid Transaction Information",
      "460" => "Processor Feature not Available",
      "461" => "Unsupported Card Type"
    }

    class << self
      def build_from_string(response_string)
        params = response_string.split("&").inject({}) do |hash, string_pair|
          key, val = string_pair.split("=")
          hash.merge(key.to_sym => val)
        end

        self.new(params)
      end
    end

    attr_reader :transaction_id, :message, :response_code

    def initialize(params)
      @response = params[:response]
      @transaction_id = params[:transactionid]
      @response_code = params[:response_code]
      @message = params[:responsetext]
    end

    def approved?
      @response == RESPONSE[:approved]
    end

    def declined?
      @response == RESPONSE[:declined]
    end

    def has_errors?
      @response == RESPONSE[:errors]
    end

    def response_code_message
      RESPONSE_CODE_MESSAGES[@response_code] || DEFAULT_MESSAGE
    end
  end
end

