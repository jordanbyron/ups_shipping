require 'rubygems'
require 'builder'
require 'nokogiri'

require_relative 'ups_shipping/configuration'
require_relative 'ups_shipping/connection'
require_relative 'ups_shipping/request'
require_relative 'ups_shipping/response'

require_relative 'ups_shipping/shipment_accept_request'
require_relative 'ups_shipping/shipment_accept_response'
require_relative 'ups_shipping/shipment_confirm_request'
require_relative 'ups_shipping/shipment_confirm_response'
require_relative 'ups_shipping/void_shipment_request'
require_relative 'ups_shipping/void_shipment_response'

require_relative 'ups_shipping/package'
require_relative 'ups_shipping/carrier'

module UpsShipping
  ConfigurationError = Class.new(StandardError)
end