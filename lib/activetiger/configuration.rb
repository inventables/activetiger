module ActiveTiger
  # The Configuration class is responsible for determining your username/password
  # based on your given RAILS_ENV and RAILS_ROOT. It looks for a yaml configuration
  # file at:
  #   #{RAILS_ROOT}/config/activetiger/#{RAILS_ENV}.yml
  #
  # A sample test configuration would be:
  #   username: demo
  #   password: password
  class Configuration
    def initialize
      config_path = File.join(RAILS_ROOT, "config", "activetiger", "#{RAILS_ENV}.yml")
      @config = YAML.load(File.read(config_path))
    end

    def username
      @config["username"]
    end

    def password
      @config["password"]
    end
  end
end

