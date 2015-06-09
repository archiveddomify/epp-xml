require 'client_transaction_id'

class EppXml
  class Domain
    include ClientTransactionId

    def info(xml_params = {}, custom_params = {})
      build('info', xml_params, custom_params)
    end

    def check(xml_params = {}, custom_params = {})
      build('check', xml_params, custom_params)
    end

    def delete(xml_params = {}, custom_params = {})
      build('delete', xml_params, custom_params)
    end

    def renew(xml_params = {}, custom_params = {})
      build('renew', xml_params, custom_params)
    end

    def create(xml_params = {}, dnssec_params = {}, custom_params = {})
      xml = Builder::XmlMarkup.new

      xml.instruct!(:xml, standalone: 'no')
      xml.epp('xmlns' => 'urn:ietf:params:xml:ns:epp-1.0') do
        xml.command do
          xml.create do
            xml.tag!('domain:create', 'xmlns:domain' => 'urn:ietf:params:xml:ns:domain-1.0') do
              EppXml.generate_xml_from_hash(xml_params, xml, 'domain:')
            end
          end

          xml.extension do
            xml.tag!('secDNS:create', 'xmlns:secDNS' => 'urn:ietf:params:xml:ns:secDNS-1.1') do
              EppXml.generate_xml_from_hash(dnssec_params, xml, 'secDNS:')
            end if dnssec_params.any?

            xml.tag!('eis:extdata',
              'xmlns:eis' => 'https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/eis-1.0.xsd') do
              EppXml.generate_xml_from_hash(custom_params, xml, 'eis:')
            end if custom_params.any?
          end if dnssec_params.any? || custom_params.any?

          xml.clTRID(clTRID) if clTRID
        end
      end
    end

    def update(xml_params = {}, dnssec_params = {}, custom_params = {})
      xml = Builder::XmlMarkup.new

      xml.instruct!(:xml, standalone: 'no')
      xml.epp('xmlns' => 'urn:ietf:params:xml:ns:epp-1.0') do
        xml.command do
          xml.update do
            xml.tag!('domain:update', 'xmlns:domain' => 'urn:ietf:params:xml:ns:domain-1.0') do
              EppXml.generate_xml_from_hash(xml_params, xml, 'domain:')
            end
          end

          xml.extension do
            xml.tag!('secDNS:update', 'xmlns:secDNS' => 'urn:ietf:params:xml:ns:secDNS-1.1') do
              EppXml.generate_xml_from_hash(dnssec_params, xml, 'secDNS:')
            end

            xml.tag!('eis:extdata',
              'xmlns:eis' => 'https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/eis-1.0.xsd') do
              EppXml.generate_xml_from_hash(custom_params, xml, 'eis:')
            end if custom_params.any?
          end if dnssec_params.any? || custom_params.any?

          xml.clTRID(clTRID) if clTRID
        end
      end
    end

    def transfer(xml_params = {}, op = 'query', custom_params = {})
      xml = Builder::XmlMarkup.new

      xml.instruct!(:xml, standalone: 'no')
      xml.epp('xmlns' => 'urn:ietf:params:xml:ns:epp-1.0') do
        xml.command do
          xml.transfer('op' => op) do
            xml.tag!('domain:transfer', 'xmlns:domain' => 'urn:ietf:params:xml:ns:domain-1.0') do
              EppXml.generate_xml_from_hash(xml_params, xml, 'domain:')
            end
          end

          EppXml.custom_ext(xml, custom_params)
          xml.clTRID(clTRID) if clTRID
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
            xml.tag!("domain:#{command}", 'xmlns:domain' => 'urn:ietf:params:xml:ns:domain-1.0') do
              EppXml.generate_xml_from_hash(xml_params, xml, 'domain:')
            end
          end

          EppXml.custom_ext(xml, custom_params)
          xml.clTRID(clTRID) if clTRID
        end
      end
    end
  end
end
