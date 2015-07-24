require 'client_transaction_id'

class EppXml
  class Keyrelay
    include ClientTransactionId

    def keyrelay(xml_params = {}, custom_params = {})
      xml = Builder::XmlMarkup.new

      xml.instruct!(:xml, standalone: 'no')
      xml.epp(
        'xmlns' => 'urn:ietf:params:xml:ns:epp-1.0',
        'xmlns:secDNS' => 'urn:ietf:params:xml:ns:secDNS-1.1',
        'xmlns:domain' => 'https://epp.tld.ee/schema/domain-eis-1.0.xsd',
        'xmlns:ext' => 'urn:ietf:params:xml:ns:keyrelay-1.0'
      ) do
        xml.tag!('command') do
          xml.tag!('ext:keyrelay') do

            xml.tag!('ext:name', xml_params[:name][:value])

            xml.tag!('ext:keyData') do
              EppXml.generate_xml_from_hash(xml_params[:keyData], xml, 'secDNS:')
            end

            xml.tag!('ext:authInfo') do
              EppXml.generate_xml_from_hash(xml_params[:authInfo], xml, 'domain:')
            end

            xml.tag!('ext:expiry') do
              EppXml.generate_xml_from_hash(xml_params[:expiry], xml, 'ext:')
            end if xml_params[:expiry]

          end

          xml.tag!('eis:extdata',
            'xmlns:eis' => 'https://epp.tld.ee/schema/eis-1.0.xsd') do
            EppXml.generate_xml_from_hash(custom_params, xml, 'eis:')
          end if custom_params.any?

          xml.tag!('ext:clTRID', clTRID) if clTRID
        end
      end
    end
  end
end
