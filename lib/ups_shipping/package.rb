require 'base64'

module UpsShipping
  class Package
    attr_accessor :tracking_number, :service_options_charges,
      :label_format, :label_image, :label_html_image

    def initialize(options = {})
      options.keys.each do |key|
        self.send("#{key}=", options[key])
      end
    end

    def save_label(path)
      return unless has_label?

      full_path = File.join(path, [tracking_number, label_format].join('.'))

      File.open(full_path, 'wb') do|f|
        f.write(Base64.decode64(label_image))
      end
    end

    def has_label?
      label_image
    end
  end
end