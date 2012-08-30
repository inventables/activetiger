module ActiveTiger
  # The Configuration class is responsible for determining your username/password
  # based on your given Rails.env and Rails.env. It looks for a yaml configuration
  # file at:
  #   #{Rails.env}/config/activetiger/#{Rails.env}.yml
  #
  # A sample test configuration would be:
  #   username: demo
  #   password: password
  class Configuration
    def initialize
      config_path = File.join(Rails.root, "config", "activetiger", "#{Rails.env}.yml")
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

