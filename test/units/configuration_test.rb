require_relative "../helper"

describe "Configuration" do
  it "loads configuration details from a file" do
    file = "#{File.dirname(__FILE__)}/../fixtures/configuration.yml"

    UpsShipping::Configuration.load_from_file(file)

    UpsShipping::Configuration.account_number.must_equal "Six Digit UPS Account Number"
  end

  it "loads configuration details via a hash" do
    UpsShipping::Configuration.load('account_number' => "C1234")

    UpsShipping::Configuration.account_number.must_equal "C1234"
  end
end