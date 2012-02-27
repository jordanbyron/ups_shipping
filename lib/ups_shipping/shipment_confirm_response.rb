module UpsShipping
  class ShipmentConfirmResponse < Response
    attr_accessor :transportation_charges, :service_options_charges,
      :total_charges, :billing_weight, :billing_weight_unit,
      :shipment_identification_number, :shipment_digest

    def parse_response
      self.xml = Nokogiri::XML.parse(body)

      if xml.nil? or attr('Response').nil?
        self.error_code = "NIL"
        self.error_description = "Response from shipment confirm response was nil."
        return
      end

      self.status_code        = attr('ResponseStatusCode')
      self.status_description = attr('ResponseStatusDescription')

      if success?
        self.transportation_charges  = attr("ShipmentCharges/TransportationCharges/MonetaryValue")
        self.service_options_charges = attr("ShipmentCharges/ServiceOptionsCharges/MonetaryValue")
        self.total_charges           = attr("ShipmentCharges/TotalCharges/MonetaryValue")

        self.billing_weight      = attr("BillingWeight/Weight")
        self.billing_weight_unit = attr("BillingWeight/UnitOfMeasure/Code")

        self.shipment_identification_number = attr("ShipmentIdentificationNumber")
        self.shipment_digest                = attr("ShipmentDigest")
      else
        self.error_severity    = attr("ErrorSeverity")
        self.error_code        = attr("ErrorCode")
        self.error_description = attr("ErrorDescription")
      end

    end
  end
end
