module EppXmlCore
  module Domain
    def info(xml_params = {})
      build('info', xml_params)
    end

    def check(xml_params = {})
      build('check', xml_params)
    end

    def delete(xml_params = {})
      build('delete', xml_params)
    end

    def renew(xml_params = {})
      build('renew', xml_params)
    end

    def create(xml_params = {}, dnssec_params = {})
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
            end
          end if dnssec_params != false
          xml.clTRID("#{EppXml.cl_trid_prefix}#{Time.now.to_i}")
        end
      end
    end

    def update(xml_params = {}, dnssec_params = false)
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
            xml.tag!('secDNS:create', 'xmlns:secDNS' => 'urn:ietf:params:xml:ns:secDNS-1.1') do
              EppXml.generate_xml_from_hash(dnssec_params, xml, 'secDNS:')
            end
          end if dnssec_params != false
          xml.clTRID("#{EppXml.cl_trid_prefix}#{Time.now.to_i}")
        end
      end
    end

    def transfer(xml_params = {}, op = 'query')
      xml = Builder::XmlMarkup.new

      xml.instruct!(:xml, standalone: 'no')
      xml.epp('xmlns' => 'urn:ietf:params:xml:ns:epp-1.0') do
        xml.command do
          xml.transfer('op' => op) do
            xml.tag!('domain:transfer', 'xmlns:domain' => 'urn:ietf:params:xml:ns:domain-1.0') do
              EppXml.generate_xml_from_hash(xml_params, xml, 'domain:')
            end
          end
          xml.clTRID("#{EppXml.cl_trid_prefix}#{Time.now.to_i}")
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
            xml.tag!("domain:#{command}", 'xmlns:domain' => 'urn:ietf:params:xml:ns:domain-1.0') do
              EppXml.generate_xml_from_hash(xml_params, xml, 'domain:')
            end
          end
          xml.clTRID("#{EppXml.cl_trid_prefix}#{Time.now.to_i}")
        end
      end
    end
  end
end
