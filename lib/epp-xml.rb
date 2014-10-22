require 'active_support'
require 'builder'

class EppXml
  def self.login(xml_params = {})
    defaults = {
      clID: { value: 'user' },
      pw: { value: 'pw' },
      options: {
        version: { value: '1.0' },
        lang: { value: 'en' }
      },
      svcs: {
        _objURIs: [
          objURI: { value: 'urn:ietf:params:xml:ns:contact-1.0' }
        ]
      }
    }

    xml_params = defaults.deep_merge(xml_params)

    xml = Builder::XmlMarkup.new

    xml.instruct!(:xml, standalone: 'no')
    xml.epp(
      'xmlns' => 'urn:ietf:params:xml:ns:epp-1.0',
      'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
      'xsi:schemaLocation' => 'urn:ietf:params:xml:ns:epp-1.0 epp-1.0.xsd'
    ) do
      xml.command do
        xml.login do
          generate_xml_from_hash(xml_params, xml)
        end
        xml.clTRID 'ABC-12345'
      end
    end
  end

  private

  def self.generate_xml_from_hash(xml_params, xml, ns = '')
    xml_params.each do |k, v|
      # Value is a hash which has string type value
      if v.is_a?(Hash) && v[:value].is_a?(String)
        xml.tag!("#{ns}#{k}", v[:value], v[:attrs])
      # Value is a hash which is nested
      elsif v.is_a?(Hash)
        xml.tag!("#{ns}#{k}") do
          generate_xml_from_hash(v, xml, ns)
        end
      # Value is an array
      elsif v.is_a?(Array)
        if k.to_s.start_with?('_')
          v.each do |x|
            generate_xml_from_hash(x, xml, ns)
          end
        else
          xml.tag!("#{ns}#{k}") do
            v.each do |x|
              generate_xml_from_hash(x, xml, ns)
            end
          end
        end
      end
    end
  end
end
