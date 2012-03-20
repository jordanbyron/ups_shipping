module UpsShipping
  class VoidShipmentResponse < Response
    attr_accessor :voided, :tracking_number

    def voided?
      self.voided == '1'
    end

    def parse_response
      self.xml = Nokogiri::XML.parse(body)

      self.status_code        = attr('ResponseStatusCode')
      self.status_description = attr('ResponseStatusDescription')

      if success?
        self.tracking_number = attr("TrackingNumber")
        self.voided          = attr("PackageLevelResults/StatusCode") == '1'
      else
        self.error_severity    = attr("ErrorSeverity")
        self.error_code        = attr("ErrorCode")
        self.error_description = attr("ErrorDescription")

        self.voided = false
      end
    end
  end
end
