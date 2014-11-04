require 'spec_helper'

describe EppXml::Contact do
  it 'generates valid check xml' do
    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <check>
            <contact:check
             xmlns:contact="urn:ietf:params:xml:ns:contact-1.0" />
          </check>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    generated = Nokogiri::XML(EppXml::Contact.check).to_s.squish
    expect(generated).to eq(expected)

    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <check>
            <contact:check
             xmlns:contact="urn:ietf:params:xml:ns:contact-1.0">
              <contact:id>sh8013</contact:id>
              <contact:id>sah8013</contact:id>
              <contact:id>8013sah</contact:id>
            </contact:check>
          </check>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    xml = EppXml::Contact.check({
      _anonymus: [
        { id: { value: 'sh8013' } },
        { id: { value: 'sah8013' } },
        { id: { value: '8013sah' } }
      ]
    })

    generated = Nokogiri::XML(xml).to_s.squish
    expect(generated).to eq(expected)
  end

  it 'generates valid info xml' do
    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <info>
            <contact:info
             xmlns:contact="urn:ietf:params:xml:ns:contact-1.0" />
          </info>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    generated = Nokogiri::XML(EppXml::Contact.info).to_s.squish
    expect(generated).to eq(expected)

    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <info>
            <contact:info
             xmlns:contact="urn:ietf:params:xml:ns:contact-1.0">
              <contact:id>sh8013</contact:id>
              <contact:authInfo>
                <contact:pw>2fooBAR</contact:pw>
              </contact:authInfo>
            </contact:info>
          </info>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    xml = EppXml::Contact.info({
      id: { value: 'sh8013' },
      authInfo: {
        pw: { value: '2fooBAR' }
      }
    })

    generated = Nokogiri::XML(xml).to_s.squish
    expect(generated).to eq(expected)
  end


end
