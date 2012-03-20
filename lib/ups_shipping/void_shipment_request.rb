module UpsShipping
  class VoidShipmentRequest < Request
    attr_accessor :tracking_number

    def initialize(tracking_number)
      self.tracking_number = tracking_number
    end

    def path_suffix
      "Void"
    end

    def body
      xml = Builder::XmlMarkup.new(:indent => 2)

      build_credentials(xml)

      xml.instruct!(:xml, :encoding => "UTF-8")
      xml.VoidShipmentRequest do
        xml.Request do
          xml.TransactionReference do
            # Custom attribute which is returned by the server
            xml.CustomerContext
          end

          xml.RequestAction 1
        end

        xml.ShipmentIdentificationNumber tracking_number
      end
    end

  end
end
