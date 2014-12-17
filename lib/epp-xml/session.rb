module EppXmlCore
  module Session
    def login(xml_params = {})
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
            EppXml.generate_xml_from_hash(xml_params, xml)
          end
          xml.clTRID(EppXml.clTRID)
        end
      end
    end

    def poll(xml_params = {})
      defaults = {
        poll: { value: '', attrs: { op: 'req' } }
      }

      xml_params = defaults.deep_merge(xml_params)

      xml = Builder::XmlMarkup.new

      xml.instruct!(:xml, standalone: 'no')
      xml.epp('xmlns' => 'urn:ietf:params:xml:ns:epp-1.0') do
        xml.command do
          EppXml.generate_xml_from_hash(xml_params, xml)
          xml.clTRID(EppXml.clTRID)
        end
      end

    end
  end
end
