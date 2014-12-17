require 'spec_helper'

describe EppXml::Contact do
  before(:each) { EppXml.cl_trid = 'ABC-12345' }

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

  it 'generates valid transfer xml' do
    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <transfer op="query">
            <contact:transfer
             xmlns:contact="urn:ietf:params:xml:ns:contact-1.0" />
          </transfer>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    generated = Nokogiri::XML(EppXml::Contact.transfer).to_s.squish
    expect(generated).to eq(expected)

    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <transfer op="query">
            <contact:transfer
             xmlns:contact="urn:ietf:params:xml:ns:contact-1.0">
              <contact:id>sh8013</contact:id>
              <contact:authInfo>
                <contact:pw>2fooBAR</contact:pw>
              </contact:authInfo>
            </contact:transfer>
          </transfer>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    xml = EppXml::Contact.transfer({
      id: { value: 'sh8013' },
      authInfo: {
        pw: { value: '2fooBAR' }
      }
    }, 'query')

    generated = Nokogiri::XML(xml).to_s.squish
    expect(generated).to eq(expected)
  end

  it 'generates valid create xml' do
    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <create>
            <contact:create
             xmlns:contact="urn:ietf:params:xml:ns:contact-1.0" />
          </create>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    generated = Nokogiri::XML(EppXml::Contact.create).to_s.squish
    expect(generated).to eq(expected)

    ###

    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <create>
            <contact:create
             xmlns:contact="urn:ietf:params:xml:ns:contact-1.0">
              <contact:id>sh8013</contact:id>
              <contact:postalInfo type="int">
                <contact:name>John Doe</contact:name>
                <contact:org>Example Inc.</contact:org>
                <contact:addr>
                  <contact:street>123 Example Dr.</contact:street>
                  <contact:street>Suite 100</contact:street>
                  <contact:city>Dulles</contact:city>
                  <contact:sp>VA</contact:sp>
                  <contact:pc>20166-6503</contact:pc>
                  <contact:cc>US</contact:cc>
                </contact:addr>
              </contact:postalInfo>
              <contact:voice x="1234">+1.7035555555</contact:voice>
              <contact:fax>+1.7035555556</contact:fax>
              <contact:email>jdoe@example.com</contact:email>
              <contact:authInfo>
                <contact:pw>2fooBAR</contact:pw>
              </contact:authInfo>
              <contact:disclose flag="0">
                <contact:voice/>
                <contact:email/>
              </contact:disclose>
            </contact:create>
          </create>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    xml = EppXml::Contact.create({
      id: { value: 'sh8013' },
      postalInfo: { value: {
        name: { value: 'John Doe' },
        org: { value: 'Example Inc.' },
        addr: [
          { street: { value: '123 Example Dr.' } },
          { street: { value: 'Suite 100' } },
          { city: { value: 'Dulles' } },
          { sp: { value: 'VA' } },
          { pc: { value: '20166-6503' } },
          { cc: { value: 'US' } }
        ]
      }, attrs: { type: 'int' } },
      voice: { value: '+1.7035555555', attrs: { x: '1234' } },
      fax: { value: '+1.7035555556' },
      email: { value: 'jdoe@example.com' },
      authInfo: {
        pw: { value: '2fooBAR' }
      },
      disclose: { value: {
        voice: { value: '' },
        email: { value: '' }
      }, attrs: { flag: '0' } }
    })

    generated = Nokogiri::XML(xml).to_s.squish
    expect(generated).to eq(expected)
  end

  it 'generates valid delete xml' do
    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <delete>
            <contact:delete
             xmlns:contact="urn:ietf:params:xml:ns:contact-1.0" />
          </delete>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    generated = Nokogiri::XML(EppXml::Contact.delete).to_s.squish
    expect(generated).to eq(expected)

    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <delete>
            <contact:delete
             xmlns:contact="urn:ietf:params:xml:ns:contact-1.0">
              <contact:id>sh8013</contact:id>
            </contact:delete>
          </delete>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    xml = EppXml::Contact.delete({
      id: { value: 'sh8013' }
    })

    generated = Nokogiri::XML(xml).to_s.squish
    expect(generated).to eq(expected)
  end

  it 'generates valid update xml' do
    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <update>
            <contact:update
             xmlns:contact="urn:ietf:params:xml:ns:contact-1.0" />
          </update>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    generated = Nokogiri::XML(EppXml::Contact.update).to_s.squish
    expect(generated).to eq(expected)

    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <update>
            <contact:update
             xmlns:contact="urn:ietf:params:xml:ns:contact-1.0">
              <contact:id>sh8013</contact:id>
              <contact:add>
                <contact:status s="clientDeleteProhibited"/>
              </contact:add>
              <contact:chg>
                <contact:postalInfo type="int">
                  <contact:org/>
                  <contact:addr>
                    <contact:street>124 Example Dr.</contact:street>
                    <contact:street>Suite 200</contact:street>
                    <contact:city>Dulles</contact:city>
                    <contact:sp>VA</contact:sp>
                    <contact:pc>20166-6503</contact:pc>
                    <contact:cc>US</contact:cc>
                  </contact:addr>
                </contact:postalInfo>
                <contact:voice>+1.7034444444</contact:voice>
                <contact:fax/>
                <contact:authInfo>
                  <contact:pw>2fooBAR</contact:pw>
                </contact:authInfo>
                <contact:disclose flag="1">
                  <contact:voice/>
                  <contact:email/>
                </contact:disclose>
              </contact:chg>
            </contact:update>
          </update>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    xml = EppXml::Contact.update({
      id: { value: 'sh8013' },
      add: [
        { status: { value: '', attrs: { s: 'clientDeleteProhibited' } } }
      ],
      chg: [
        {
          postalInfo: { value: {
            org: { value: '' },
            addr: [
              { street: { value: '124 Example Dr.' } },
              { street: { value: 'Suite 200' } },
              { city: { value: 'Dulles' } },
              { sp: { value: 'VA' } },
              { pc: { value: '20166-6503' } },
              { cc: { value: 'US' } }
            ]
          }, attrs: { type: 'int' } }
        },
        { voice: { value: '+1.7034444444' } },
        { fax: { value: ''} },
        { authInfo: { pw: { value: '2fooBAR' } } },
        {
          disclose: { value: {
            voice: { value: '' },
            email: { value: '' }
          }, attrs: { flag: '1' } }
        }
      ]
    })

    generated = Nokogiri::XML(xml).to_s.squish
    expect(generated).to eq(expected)
  end
end
