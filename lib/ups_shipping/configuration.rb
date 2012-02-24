require 'yaml'

module UpsShipping
  module Configuration
    extend self

    attr_accessor :account_number, :base_url, :log,
      :access_license_number, :user_id, :password, :shipper, :ship_from

    def load(data)
      raise ConfigurationError unless data

      self.account_number        = data['account_number']
      self.base_url              = URI.parse(data['base_url']) if data['base_url']
      self.access_license_number = data['access_license_number']
      self.user_id               = data['user_id']
      self.password              = data['password']
      self.shipper               = data['shipper']
      self.ship_from             = data['ship_from']

      data['log'] ||= STDERR
      self.log = data['log']
    end

    def load_from_file(filename)
      load(YAML.load_file(filename))
    end
  end
end
