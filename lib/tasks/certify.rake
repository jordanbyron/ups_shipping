require 'fileutils'

# From the UPS API Docs
#
# UPS requires that customers pass a Certification process prior to shipping actual
# (billable) packages. The Certification Process is as follows:
#
# 1. Ship five shipments in the Customer Integration Environment (CIE).
#    These shipments must be valid shipments but may contain any combination of
#    origins, destinations and services. At least one of these tests must produce
#    a High Value Report by including a shipment with an InsuredValue greater than
#    $999.
#
# 2. Void any four of the UPS-defined “Void” test cases in CIE.
#
# 3. If you are producing GIF images, please e-mail the following 39 files along
#    with your UPS User ID and Access key to uoltects@ups.com:
#
#    - The requests and responses of the ShipConfirm and ShipAccept XML documents
#      from all five shipments (20 files).
#    - The resulting GIF images of the label from all five shipments (5 files).
#    - The resulting images of the High Value Report for at least one shipment (1 file).
#    - The HTML pages containing the scaling information for the label from all
#      five shipments (5 files).
#    - The requests and responses of all the Void XML documents (8 files).

desc 'Issues and saves the required API commands for UPS certification'
task :certify => :environment do
  mkdir_p("certification")

  UpsShipping::Configuration.load_from_file("ups.yml")
  UpsShipping::Configuration.log = "/dev/null"

  connection = UpsShipping::Connection.new

  # Generate 5 shipments
  #
  5.times do |n|
    request_hash = package_hash("#{n} package", n + 996)

    confirm_request = UpsShipping::ShipmentConfirmRequest.new(request_hash)

    save_xml confirm_request.body, "certification/confirm_request_#{n}.xml"

    confirm_response = connection.confirm_shipment(request_hash)

    abort("Confirm Failed") unless confirm_response.success?

    save_xml confirm_response.body, "certification/confirm_response_#{n}.xml"

    accept_request = UpsShipping::ShipmentAcceptRequest.new(confirm_response.shipment_digest)

    save_xml accept_request.body, "certification/accept_request_#{n}.xml"

    accept_response = connection.accept_shipment(confirm_response.shipment_digest)

    abort("Accept Failed") unless accept_response.success?

    save_xml accept_response.body, "certification/accept_response_#{n}.xml"
  end
end

private

def save_xml(data, file_name)
  File.open(file_name, "w") {|f| f.write(data) }
end

def package_hash(description, value)
  {
    :description => description,
    :service_code => "03",
    :ship_to => {
      'company_name'   => "UPS Shippers, INC",
      'attention_name' => "Ben Hughes",
      'phone_number'   => "123-123-1234",
      'address1'       => "123 Address",
      'address2'       => "Apartment 2",
      'address3'       => "Other",
      'city'           => "Rochester",
      'state'          => "NY",
      'postal_code'    => "14623",
      'country'        => "US"
    },
    :packages => [
      {
        :description        => description,
        :reference_number   => "RA1234",
        :packing_type_code  => '02',
        :insured_value      => value,
        :weight             => 14.1,
        :barcode => true
      }
    ]
  }
end
