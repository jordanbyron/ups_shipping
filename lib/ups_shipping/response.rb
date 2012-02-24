module UpsShipping
  class Response
    attr_accessor :body, :headers, :request, :xml

    attr_accessor :status_code
    attr_accessor :status_description
    attr_accessor :error_severity
    attr_accessor :error_code
    attr_accessor :error_description

    def initialize(body, request = nil)
      self.body    = body
      self.request = request
      parse_response
    end

    def success?
      status_code == '1'
    end

    def inspect
      if error_code
        "#{error_code}: #{error_description}"
      else
        "#{status_code}: #{status_description}"
      end
    end

    private

    def parse_response
      raise "Must Implement"
    end

    def attr(key)
      attribute = xml.at(key)

      if attribute
        attribute.content
      else
        nil
      end
    end
  end
end
