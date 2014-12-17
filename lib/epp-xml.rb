require 'active_support'
require 'builder'
require 'epp-xml/session'
require 'epp-xml/domain'
require 'epp-xml/contact'
require 'epp-xml/keyrelay'

module EppXml
  class Session
    extend ::EppXmlCore::Session
  end

  class Domain
    extend ::EppXmlCore::Domain
  end

  class Contact
    extend ::EppXmlCore::Contact
  end

  class Keyrelay
    extend ::EppXmlCore::Keyrelay
  end

  class << self
    attr_accessor :cl_trid_prefix, :cl_trid

    def clTRID
      cl_trid || "#{cl_trid_prefix}-#{Time.now.to_i}"
    end

    def generate_xml_from_hash(xml_params, xml, ns = '')
      xml_params.each do |k, v|
        # Value is a hash which has string type value
        if v.is_a?(Hash) && v[:value].is_a?(String)
          xml.tag!("#{ns}#{k}", v[:value], v[:attrs])
        # Value is a hash which is nested
        elsif v.is_a?(Hash)
          attrs = v.delete(:attrs)
          value = v.delete(:value) || v
          xml.tag!("#{ns}#{k}", attrs) do
            generate_xml_from_hash(value, xml, ns)
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
end
