require 'active_support'
require 'builder'
require 'epp-xml/session'
require 'epp-xml/domain'
require 'epp-xml/contact'

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
