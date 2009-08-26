module ActiveTiger
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

