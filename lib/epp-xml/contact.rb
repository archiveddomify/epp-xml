require 'client_transaction_id'

class EppXml
  class Contact
    include ClientTransactionId

    def create(xml_params = {}, custom_params = {})
      build('create', xml_params, custom_params)
    end

    def check(xml_params = {}, custom_params = {})
      build('check', xml_params, custom_params)
    end

    def info(xml_params = {}, custom_params = {})
      build('info', xml_params, custom_params)
    end

    def delete(xml_params = {}, custom_params = {})
      build('delete', xml_params, custom_params)
    end

    def update(xml_params = {}, custom_params = {})
      build('update', xml_params, custom_params)
    end

    def transfer(xml_params = {}, op = 'query', custom_params = {})
      xml = Builder::XmlMarkup.new

      xml.instruct!(:xml, standalone: 'no')
      xml.epp('xmlns' => 'urn:ietf:params:xml:ns:epp-1.0') do
        xml.command do
          xml.transfer('op' => op) do
            xml.tag!('contact:transfer', 'xmlns:contact' => 'urn:ietf:params:xml:ns:contact-1.0') do
              EppXml.generate_xml_from_hash(xml_params, xml, 'contact:')
            end
          end

          EppXml.custom_ext(xml, custom_params)
          xml.clTRID(clTRID)
        end
      end
    end

    private

    def build(command, xml_params, custom_params)
      xml = Builder::XmlMarkup.new

      xml.instruct!(:xml, standalone: 'no')
      xml.epp('xmlns' => 'urn:ietf:params:xml:ns:epp-1.0') do
        xml.command do
          xml.tag!(command) do
            xml.tag!("contact:#{command}", 'xmlns:contact' => 'urn:ietf:params:xml:ns:contact-1.0') do
              EppXml.generate_xml_from_hash(xml_params, xml, 'contact:')
            end
          end

          EppXml.custom_ext(xml, custom_params)
          xml.clTRID(clTRID)
        end
      end
    end
  end
end
