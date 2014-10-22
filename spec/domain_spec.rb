require 'spec_helper'

describe EppXml::Domain do
  it 'generates valid create xml' do
    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <create>
            <domain:create
             xmlns:domain="urn:ietf:params:xml:ns:domain-1.0">
              <domain:name>example.ee</domain:name>
              <domain:period unit="y">1</domain:period>
              <domain:ns>
                <domain:hostObj>ns1.example.net</domain:hostObj>
                <domain:hostObj>ns2.example.net</domain:hostObj>
              </domain:ns>
              <domain:registrant>jd1234</domain:registrant>
              <domain:contact type="admin">sh8013</domain:contact>
              <domain:contact type="tech">sh8013</domain:contact>
              <domain:contact type="tech">sh801333</domain:contact>
            </domain:create>
          </create>
          <extension>
          <secDNS:create xmlns:secDNS="urn:ietf:params:xml:ns:secDNS-1.1">
            <secDNS:keyData>
              <secDNS:flags>257</secDNS:flags>
              <secDNS:protocol>3</secDNS:protocol>
              <secDNS:alg>5</secDNS:alg>
              <secDNS:pubKey>AwEAAddt2AkLfYGKgiEZB5SmIF8EvrjxNMH6HtxWEA4RJ9Ao6LCWheg8</secDNS:pubKey>
            </secDNS:keyData>
          </secDNS:create>
          </extension>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    generated = Nokogiri::XML(EppXml::Domain.create).to_s.squish
    expect(generated).to eq(expected)

    ###

    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <create>
            <domain:create
             xmlns:domain="urn:ietf:params:xml:ns:domain-1.0">
              <domain:name>one.ee</domain:name>
              <domain:period unit="d">345</domain:period>
              <domain:ns>
                <domain:hostObj>ns1.test.net</domain:hostObj>
                <domain:hostObj>ns2.test.net</domain:hostObj>
              </domain:ns>
              <domain:registrant>32fsdaf</domain:registrant>
              <domain:contact type="admin">2323rafaf</domain:contact>
              <domain:contact type="tech">3dgxx</domain:contact>
              <domain:contact type="tech">345xxv</domain:contact>
            </domain:create>
          </create>
          <extension>
          <secDNS:create xmlns:secDNS="urn:ietf:params:xml:ns:secDNS-1.1">
            <secDNS:keyData>
              <secDNS:flags>257</secDNS:flags>
              <secDNS:protocol>3</secDNS:protocol>
              <secDNS:alg>5</secDNS:alg>
              <secDNS:pubKey>AwEAAddt2AkLfYGKgiEZB5SmIF8EvrjxNMH6HtxWEA4RJ9Ao6LCWheg8</secDNS:pubKey>
            </secDNS:keyData>
          </secDNS:create>
          </extension>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    xml = EppXml::Domain.create({
      name: { value: 'one.ee' },
      period: { value: '345', attrs: { unit: 'd' } },
      ns: [
        { hostObj: { value: 'ns1.test.net' } },
        { hostObj: { value: 'ns2.test.net' } }
      ],
      registrant: { value: '32fsdaf' },
      _other: [
        { contact: { value: '2323rafaf', attrs: { type: 'admin' } } },
        { contact: { value: '3dgxx', attrs: { type: 'tech' } } },
        { contact: { value: '345xxv', attrs: { type: 'tech' } } }
      ]
    })

    generated = Nokogiri::XML(xml).to_s.squish
    expect(generated).to eq(expected)

    ###

    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <create>
            <domain:create
             xmlns:domain="urn:ietf:params:xml:ns:domain-1.0">
              <domain:name>one.ee</domain:name>
            </domain:create>
          </create>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    xml = EppXml::Domain.create({
      name: { value: 'one.ee' },
      period: nil,
      ns: nil,
      registrant: nil,
      _other: nil
    }, false)

    generated = Nokogiri::XML(xml).to_s.squish
    expect(generated).to eq(expected)
  end

  it 'generates valid info xml' do
    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <info>
            <domain:info
             xmlns:domain="urn:ietf:params:xml:ns:domain-1.0">
              <domain:name hosts="all">example.ee</domain:name>
              <domain:authInfo>
                <domain:pw>2fooBAR</domain:pw>
              </domain:authInfo>
            </domain:info>
          </info>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    generated = Nokogiri::XML(EppXml::Domain.info).to_s.squish
    expect(generated).to eq(expected)

    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <info>
            <domain:info
             xmlns:domain="urn:ietf:params:xml:ns:domain-1.0">
              <domain:name hosts="sub">one.ee</domain:name>
              <domain:authInfo>
                <domain:pw>b3rafsla</domain:pw>
              </domain:authInfo>
            </domain:info>
          </info>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    xml = EppXml::Domain.info({
      name: { value: 'one.ee', attrs: { hosts: 'sub' } },
      authInfo: {
        pw: { value: 'b3rafsla' }
      }
    })

    generated = Nokogiri::XML(xml).to_s.squish
    expect(generated).to eq(expected)
  end
end
