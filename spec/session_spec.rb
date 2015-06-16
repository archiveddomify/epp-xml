require 'spec_helper'

describe EppXml::Session do
  let(:epp_xml) { EppXml.new(cl_trid: 'ABC-12345')}

  it 'generates valid login xml' do
    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <login>
            <clID>user</clID>
            <pw>pw</pw>
            <options>
              <version>1.0</version>
              <lang>en</lang>
            </options>
            <svcs>
              <objURI>https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/domain-eis-1.0.xsd</objURI>
              <objURI>https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/contact-eis-1.0.xsd</objURI>
              <objURI>urn:ietf:params:xml:ns:host-1.0</objURI>
              <objURI>urn:ietf:params:xml:ns:keyrelay-1.0</objURI>
              <svcExtension>
                <extURI>urn:ietf:params:xml:ns:secDNS-1.1</extURI>
                <extURI>https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/eis-1.0.xsd</extURI>
              </svcExtension>
            </svcs>
          </login>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    generated = Nokogiri::XML(epp_xml.session.login).to_s.squish
    expect(generated).to eq(expected)
  end

  it 'generates valid login xml with new pw' do
    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <login>
            <clID>user</clID>
            <pw>pw</pw>
            <newPW>new_pw</newPW>
            <options>
              <version>1.0</version>
              <lang>en</lang>
            </options>
            <svcs>
              <objURI>https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/domain-eis-1.0.xsd</objURI>
              <objURI>https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/contact-eis-1.0.xsd</objURI>
              <objURI>urn:ietf:params:xml:ns:host-1.0</objURI>
              <objURI>urn:ietf:params:xml:ns:keyrelay-1.0</objURI>
              <svcExtension>
                <extURI>urn:ietf:params:xml:ns:secDNS-1.1</extURI>
                <extURI>https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/eis-1.0.xsd</extURI>
              </svcExtension>
            </svcs>
          </login>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    generated = Nokogiri::XML(epp_xml.session.login(newPW: { value: 'new_pw' })).to_s.squish
    expect(generated).to eq(expected)
  end

  it 'generates valid logout xml' do
    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <logout/>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    generated = Nokogiri::XML(epp_xml.session.logout).to_s.squish
    expect(generated).to eq(expected)
  end

  it 'generates valid logout xml without clTRID' do
    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <logout/>
        </command>
      </epp>
    ').to_s.squish

    ex = EppXml.new(cl_trid: false)
    generated = Nokogiri::XML(ex.session.logout).to_s.squish
    expect(generated).to eq(expected)
  end

  it 'generates valid poll xml' do
    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <poll op="req" />
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    generated = Nokogiri::XML(epp_xml.session.poll).to_s.squish
    expect(generated).to eq(expected)

    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <poll op="ack" msgID="12345" />

          <extension>
            <eis:extdata xmlns:eis="https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/eis-1.0.xsd">
              <eis:legalDocument type="ddoc">base64</eis:legalDocument>
            </eis:extdata>
          </extension>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    xml = epp_xml.session.poll({
      poll: {
        value: '', attrs: { op: 'ack', msgID: '12345' }
      }
    }, {
      _anonymus: [
        legalDocument: { value: 'base64', attrs: { type: 'ddoc' } }
      ]
    })

    generated = Nokogiri::XML(xml).to_s.squish
    expect(generated).to eq(expected)
  end
end
