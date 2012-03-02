module UpsShipping
  class ShipmentAcceptResponse < Response
    attr_accessor :transportation_charges, :service_options_charges,
      :total_charges, :billing_weight, :billing_weight_unit, :high_value_report,
      :high_value_report_format, :shipment_identification_number, :packages

    def initialize(body, request = nil)
      self.packages = []
      super
    end

    def parse_response
      self.xml = Nokogiri::XML.parse(body)

      self.status_code        = attr('ResponseStatusCode')
      self.status_description = attr('ResponseStatusDescription')

      if success?
        self.transportation_charges  = attr('ShipmentCharges/TransportationCharges/MonetaryValue')
        self.service_options_charges = attr('ShipmentCharges/ServiceOptionsCharges/MonetaryValue')
        self.total_charges           = attr('ShipmentCharges/TotalCharges/MonetaryValue')

        self.billing_weight      = attr('BillingWeight/Weight')
        self.billing_weight_unit = attr('BillingWeight/UnitOfMeasure/Code')

        self.shipment_identification_number = attr('ShipmentIdentificationNumber')

        if attr('ControlLogReceipt')
          self.high_value_report        = attr('ControlLogReceipt/GraphicImage')
          self.high_value_report_format = attr('ControlLogReceipt/ImageFormat/Code')
        end

        xml.search('PackageResults').each do |package_result|
          package = {
            :tracking_number         => package_result.at('TrackingNumber').inner_text,
            :service_options_charges => package_result.at('ServiceOptionsCharges/MonetaryValue').content
          }

          if package_result.at('LabelImage')
            package[:label_format]     = package_result.at('LabelImage/LabelImageFormat/Code').inner_text.downcase
            package[:label_image]      = package_result.at('LabelImage/GraphicImage').content
            package[:label_html_image] = package_result.at('LabelImage/HTMLImage').content
          end

          self.packages << Package.new(package)
        end

      else
        self.error_severity    = attr("ErrorSeverity")
        self.error_code        = attr("ErrorCode")
        self.error_description = attr("ErrorDescription")
      end

    end

  end
end