module EppXmlCore
  module Contact
    def create(xml_params = {})
      build('create', xml_params)
    end

    def check(xml_params = {})
      build('check', xml_params)
    end

    def info(xml_params = {})
      build('info', xml_params)
    end

    def delete(xml_params = {})
      build('delete', xml_params)
    end

    def update(xml_params = {})
      build('update', xml_params)
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
          xml.clTRID(EppXml.clTRID)
        end
      end
    end

    private

    def build(command, xml_params)
      xml = Builder::XmlMarkup.new

      xml.instruct!(:xml, standalone: 'no')
      xml.epp('xmlns' => 'urn:ietf:params:xml:ns:epp-1.0') do
        xml.command do
          xml.tag!(command) do
            xml.tag!("contact:#{command}", 'xmlns:contact' => 'urn:ietf:params:xml:ns:contact-1.0') do
              EppXml.generate_xml_from_hash(xml_params, xml, 'contact:')
            end
          end
          xml.clTRID(EppXml.clTRID)
        end
      end
    end
  end
end
