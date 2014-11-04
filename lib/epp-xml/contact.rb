module EppXmlCore
  module Contact
    def check(xml_params = {})
      xml = Builder::XmlMarkup.new

      xml.instruct!(:xml, standalone: 'no')
      xml.epp('xmlns' => 'urn:ietf:params:xml:ns:epp-1.0') do
        xml.command do
          xml.check do
            xml.tag!('contact:check', 'xmlns:contact' => 'urn:ietf:params:xml:ns:contact-1.0') do
              EppXml.generate_xml_from_hash(xml_params, xml, 'contact:')
            end
          end
          xml.clTRID 'ABC-12345'
        end
      end
    end

    def info(xml_params = {})
      xml = Builder::XmlMarkup.new

      xml.instruct!(:xml, standalone: 'no')
      xml.epp('xmlns' => 'urn:ietf:params:xml:ns:epp-1.0') do
        xml.command do
          xml.info do
            xml.tag!('contact:info', 'xmlns:contact' => 'urn:ietf:params:xml:ns:contact-1.0') do
              EppXml.generate_xml_from_hash(xml_params, xml, 'contact:')
            end
          end
          xml.clTRID 'ABC-12345'
        end
      end
    end

    def transfer(xml_params = {}, op = 'query')
      xml = Builder::XmlMarkup.new

      xml.instruct!(:xml, standalone: 'no')
      xml.epp('xmlns' => 'urn:ietf:params:xml:ns:epp-1.0') do
        xml.command do
          xml.transfer('op' => op) do
            xml.tag!('contact:transfer', 'xmlns:contact' => 'urn:ietf:params:xml:ns:contact-1.0') do
              EppXml.generate_xml_from_hash(xml_params, xml, 'contact:')
            end
          end
          xml.clTRID 'ABC-12345'
        end
      end
    end
  end
end
