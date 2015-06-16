require 'spec_helper'

describe EppXml::Domain do
  let(:epp_xml) { EppXml.new(cl_trid: 'ABC-12345')}

  it 'generates valid create xml' do
    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <create>
            <domain:create
             xmlns:domain="https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/domain-eis-1.0.xsd" />
          </create>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    generated = Nokogiri::XML(epp_xml.domain.create).to_s.squish
    expect(generated).to eq(expected)

    ###

    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <create>
            <domain:create
             xmlns:domain="https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/domain-eis-1.0.xsd">
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
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    xml = epp_xml.domain.create({
      name: { value: 'one.ee' },
      period: { value: '345', attrs: { unit: 'd' } },
      ns: [
        { hostObj: { value: 'ns1.test.net' } },
        { hostObj: { value: 'ns2.test.net' } }
      ],
      registrant: { value: '32fsdaf' },
      _anonymus: [
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
             xmlns:domain="https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/domain-eis-1.0.xsd">
              <domain:name>one.ee</domain:name>
            </domain:create>
          </create>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    xml = epp_xml.domain.create({
      name: { value: 'one.ee' },
      period: nil,
      ns: nil,
      registrant: nil,
      _anonymus: nil
    })

    generated = Nokogiri::XML(xml).to_s.squish
    expect(generated).to eq(expected)

    ###

    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <create>
            <domain:create
             xmlns:domain="https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/domain-eis-1.0.xsd">
              <domain:name>one.ee</domain:name>
              <domain:period unit="d">345</domain:period>
              <domain:ns>
                <domain:hostAttr>
                  <domain:hostName>ns1.example.net</domain:hostName>
                  <domain:hostAddr ip="v4">192.0.2.2</domain:hostAddr>
                  <domain:hostAddr ip="v6">1080:0:0:0:8:800:200C:417A</domain:hostAddr>
                </domain:hostAttr>
                <domain:hostAttr>
                 <domain:hostName>ns2.example.net</domain:hostName>
                </domain:hostAttr>
              </domain:ns>
              <domain:registrant>32fsdaf</domain:registrant>
              <domain:contact type="admin">2323rafaf</domain:contact>
              <domain:contact type="tech">3dgxx</domain:contact>
              <domain:contact type="tech">345xxv</domain:contact>
            </domain:create>
          </create>
          <extension>
          <secDNS:create xmlns:secDNS="urn:ietf:params:xml:ns:secDNS-1.1">
            <secDNS:dsData>
              <secDNS:keyTag>12345</secDNS:keyTag>
              <secDNS:alg>3</secDNS:alg>
              <secDNS:digestType>1</secDNS:digestType>
              <secDNS:digest>49FD46E6C4B45C55D4AC</secDNS:digest>
              <secDNS:keyData>
                <secDNS:flags>0</secDNS:flags>
                <secDNS:protocol>3</secDNS:protocol>
                <secDNS:alg>5</secDNS:alg>
                <secDNS:pubKey>700b97b591ed27ec2590d19f06f88bba700b97b591ed27ec2590d19f</secDNS:pubKey>
              </secDNS:keyData>
            </secDNS:dsData>
          </secDNS:create>
          </extension>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    xml = epp_xml.domain.create({
      name: { value: 'one.ee' },
      period: { value: '345', attrs: { unit: 'd' } },
      ns: [
        { hostAttr:
          [
            { hostName: { value: 'ns1.example.net' } },
            { hostAddr: { value: '192.0.2.2', attrs: { ip: 'v4' } } },
            { hostAddr: { value: '1080:0:0:0:8:800:200C:417A', attrs: { ip: 'v6' } } }
          ]
        },
        { hostAttr:
          [
            { hostName: { value: 'ns2.example.net' } }
          ]
        }
      ],
      registrant: { value: '32fsdaf' },
      _anonymus: [
        { contact: { value: '2323rafaf', attrs: { type: 'admin' } } },
        { contact: { value: '3dgxx', attrs: { type: 'tech' } } },
        { contact: { value: '345xxv', attrs: { type: 'tech' } } }
      ]
    }, {
      _anonymus: [
        { dsData: {
            keyTag: { value: '12345' },
            alg: { value: '3' },
            digestType: { value: '1' },
            digest: { value: '49FD46E6C4B45C55D4AC' },
            keyData: {
              flags: { value: '0' },
              protocol: { value: '3' },
              alg: { value: '5' },
              pubKey: { value: '700b97b591ed27ec2590d19f06f88bba700b97b591ed27ec2590d19f' }
            }
          }
        }
      ]
    })

    generated = Nokogiri::XML(xml).to_s.squish
    expect(generated).to eq(expected)
  end

  it 'generates create with custom extension' do
    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <create>
            <domain:create
             xmlns:domain="https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/domain-eis-1.0.xsd">
              <domain:name>one.ee</domain:name>
              <domain:period unit="d">345</domain:period>
              <domain:ns>
                <domain:hostAttr>
                  <domain:hostName>ns1.example.net</domain:hostName>
                  <domain:hostAddr ip="v4">192.0.2.2</domain:hostAddr>
                  <domain:hostAddr ip="v6">1080:0:0:0:8:800:200C:417A</domain:hostAddr>
                </domain:hostAttr>
                <domain:hostAttr>
                 <domain:hostName>ns2.example.net</domain:hostName>
                </domain:hostAttr>
              </domain:ns>
              <domain:registrant>32fsdaf</domain:registrant>
              <domain:contact type="admin">2323rafaf</domain:contact>
              <domain:contact type="tech">3dgxx</domain:contact>
              <domain:contact type="tech">345xxv</domain:contact>
            </domain:create>
          </create>
          <extension>
            <eis:extdata xmlns:eis="https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/eis-1.0.xsd">
              <eis:legalDocument type="ddoc">base64</eis:legalDocument>
            </eis:extdata>
          </extension>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    xml = epp_xml.domain.create({
      name: { value: 'one.ee' },
      period: { value: '345', attrs: { unit: 'd' } },
      ns: [
        { hostAttr:
          [
            { hostName: { value: 'ns1.example.net' } },
            { hostAddr: { value: '192.0.2.2', attrs: { ip: 'v4' } } },
            { hostAddr: { value: '1080:0:0:0:8:800:200C:417A', attrs: { ip: 'v6' } } }
          ]
        },
        { hostAttr:
          [
            { hostName: { value: 'ns2.example.net' } }
          ]
        }
      ],
      registrant: { value: '32fsdaf' },
      _anonymus: [
        { contact: { value: '2323rafaf', attrs: { type: 'admin' } } },
        { contact: { value: '3dgxx', attrs: { type: 'tech' } } },
        { contact: { value: '345xxv', attrs: { type: 'tech' } } }
      ]
    }, {}, {
      _anonymus: [
        legalDocument: { value: 'base64', attrs: { type: 'ddoc' } }
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
            <domain:info
             xmlns:domain="https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/domain-eis-1.0.xsd" />
          </info>
          <clTRID>ABC-12345</clTRID>
        </command>

      </epp>
    ').to_s.squish

    generated = Nokogiri::XML(epp_xml.domain.info).to_s.squish
    expect(generated).to eq(expected)

    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <info>
            <domain:info
             xmlns:domain="https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/domain-eis-1.0.xsd">
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

    xml = epp_xml.domain.info({
      name: { value: 'one.ee', attrs: { hosts: 'sub' } },
      authInfo: {
        pw: { value: 'b3rafsla' }
      }
    })

    generated = Nokogiri::XML(xml).to_s.squish
    expect(generated).to eq(expected)
  end

  it 'generates valid check xml' do
    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <check>
            <domain:check
             xmlns:domain="https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/domain-eis-1.0.xsd" />
          </check>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    generated = Nokogiri::XML(epp_xml.domain.check).to_s.squish
    expect(generated).to eq(expected)

    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <check>
            <domain:check
             xmlns:domain="https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/domain-eis-1.0.xsd">
              <domain:name>example.ee</domain:name>
              <domain:name>example2.ee</domain:name>
              <domain:name>example3.ee</domain:name>
            </domain:check>
          </check>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    xml = epp_xml.domain.check({
      _anonymus: [
        { name: { value: 'example.ee' } },
        { name: { value: 'example2.ee' } },
        { name: { value: 'example3.ee' } }
      ]
    })

    generated = Nokogiri::XML(xml).to_s.squish
    expect(generated).to eq(expected)
  end

  it 'generates valid update xml' do
    # Detailed update
    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <update>
            <domain:update
             xmlns:domain="https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/domain-eis-1.0.xsd">
              <domain:name>example.ee</domain:name>
              <domain:add>
                <domain:ns>
                  <domain:hostObj>ns2.example.com</domain:hostObj>
                </domain:ns>
                <domain:contact type="tech">mak21</domain:contact>
                <domain:status s="clientUpdateProhibited"/>
                <domain:status s="clientHold"
                 lang="en">Payment overdue.</domain:status>
              </domain:add>
              <domain:rem>
                <domain:ns>
                  <domain:hostObj>ns1.example.com</domain:hostObj>
                </domain:ns>
                <domain:contact type="tech">sh8013</domain:contact>
                <domain:status s="clientUpdateProhibited"></domain:status>
              </domain:rem>
              <domain:chg>
                <domain:registrant>mak21</domain:registrant>
              </domain:chg>
            </domain:update>
          </update>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    xml = epp_xml.domain.update({
      name: { value: 'example.ee' },
      add: [
        { ns:
          [
            hostObj: { value: 'ns1.example.com' },
            hostObj: { value: 'ns2.example.com' }
          ]
        },
        { contact: { attrs: { type: 'tech' }, value: 'mak21' } },
        { status: { attrs: { s: 'clientUpdateProhibited' }, value: '' } },
        { status: { attrs: { s: 'clientHold', lang: 'en' }, value: 'Payment overdue.' } }
      ],
      rem: [
        ns: [
          hostObj: { value: 'ns1.example.com' }
        ],
        contact: { attrs: { type: 'tech' }, value: 'sh8013' },
        status: { attrs: { s: 'clientUpdateProhibited' }, value: '' }
      ],
      chg: [
        registrant: { value: 'mak21' }
      ]
    })

    generated = Nokogiri::XML(xml).to_s.squish
    expect(generated).to eq(expected)

    # Update with NS IP-s

    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <update>
            <domain:update
             xmlns:domain="https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/domain-eis-1.0.xsd">
              <domain:name>one.ee</domain:name>
              <domain:add>
                <domain:contact type="admin">sh8013</domain:contact>
                <domain:status s="testStatus"
                 lang="et">Payment overdue.</domain:status>
              </domain:add>
              <domain:rem>
                <domain:ns>
                  <domain:hostAttr>
                    <domain:hostName>ns1.example.net</domain:hostName>
                    <domain:hostAddr ip="v4">192.0.2.2</domain:hostAddr>
                    <domain:hostAddr ip="v6">1080:0:0:0:8:800:200C:417A</domain:hostAddr>
                  </domain:hostAttr>
                </domain:ns>
                <domain:contact type="tech">sh8013</domain:contact>
                <domain:status s="clientUpdateProhibited"></domain:status>
              </domain:rem>
              <domain:chg>
                <domain:registrant>sh8013</domain:registrant>
              </domain:chg>
            </domain:update>
          </update>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    xml = epp_xml.domain.update({
      name: { value: 'one.ee' },
      add: [
        ns: nil,
        contact: { value: 'sh8013', attrs: { type: 'admin' } },
        status: { value: 'Payment overdue.', attrs: { s: 'testStatus', lang: 'et' } }
      ],
      rem: [
        ns: [
          hostAttr: [
            { hostName: { value: 'ns1.example.net' } },
            { hostAddr: { value: '192.0.2.2', attrs: { ip: 'v4' } } },
            { hostAddr: { value: '1080:0:0:0:8:800:200C:417A', attrs: { ip: 'v6' } } }
          ]
        ],
        contact: { attrs: { type: 'tech' }, value: 'sh8013' },
        status: { attrs: { s: 'clientUpdateProhibited' }, value: '' }
      ],
      chg: [
        registrant: { value: 'sh8013' }
      ]
    })

    generated = Nokogiri::XML(xml).to_s.squish
    expect(generated).to eq(expected)

    ## Update with chg

    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <update>
            <domain:update
             xmlns:domain="https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/domain-eis-1.0.xsd">
              <domain:name>example.ee</domain:name>
              <domain:chg>
                <domain:registrant>mak21</domain:registrant>
              </domain:chg>
            </domain:update>
          </update>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    xml = epp_xml.domain.update({
      name: { value: 'example.ee' },
      chg: [
        registrant: { value: 'mak21' }
      ]
    })
    generated = Nokogiri::XML(xml).to_s.squish
    expect(generated).to eq(expected)

    ## Update extension

    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <update>
            <domain:update xmlns:domain="https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/domain-eis-1.0.xsd">
              <domain:name>example.ee</domain:name>
            </domain:update>
          </update>
          <extension>
            <secDNS:update xmlns:secDNS="urn:ietf:params:xml:ns:secDNS-1.1">
              <secDNS:add>
                <secDNS:keyData>
                  <secDNS:flags>0</secDNS:flags>
                  <secDNS:protocol>3</secDNS:protocol>
                  <secDNS:alg>5</secDNS:alg>
                  <secDNS:pubKey>700b97b591ed27ec2590d19f06f88bba700b97b591ed27ec2590d19f</secDNS:pubKey>
                </secDNS:keyData>
                <secDNS:keyData>
                  <secDNS:flags>256</secDNS:flags>
                  <secDNS:protocol>3</secDNS:protocol>
                  <secDNS:alg>254</secDNS:alg>
                  <secDNS:pubKey>841936717ae427ace63c28d04918569a841936717ae427ace63c28d0</secDNS:pubKey>
                </secDNS:keyData>
                <secDNS:dsData>
                  <secDNS:keyTag>12345</secDNS:keyTag>
                  <secDNS:alg>3</secDNS:alg>
                  <secDNS:digestType>1</secDNS:digestType>
                  <secDNS:digest>49FD46E6C4B45C55D4AC</secDNS:digest>
                  <secDNS:keyData>
                    <secDNS:flags>0</secDNS:flags>
                    <secDNS:protocol>3</secDNS:protocol>
                    <secDNS:alg>5</secDNS:alg>
                    <secDNS:pubKey>700b97b591ed27ec2590d19f06f88bba700b97b591ed27ec2590d19f</secDNS:pubKey>
                  </secDNS:keyData>
                </secDNS:dsData>
              </secDNS:add>
            </secDNS:update>
            <eis:extdata xmlns:eis="https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/eis-1.0.xsd">
              <eis:legalDocument type="ddoc">base64</eis:legalDocument>
            </eis:extdata>
          </extension>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    xml = epp_xml.domain.update({ name: { value: 'example.ee' } }, {
      add: [
        { keyData: {
            flags: { value: '0' },
            protocol: { value: '3' },
            alg: { value: '5' },
            pubKey: { value: '700b97b591ed27ec2590d19f06f88bba700b97b591ed27ec2590d19f' }
          }
        },
        {
          keyData: {
            flags: { value: '256' },
            protocol: { value: '3' },
            alg: { value: '254' },
            pubKey: { value: '841936717ae427ace63c28d04918569a841936717ae427ace63c28d0' }
          }
        },
        { dsData: {
            keyTag: { value: '12345' },
            alg: { value: '3' },
            digestType: { value: '1' },
            digest: { value: '49FD46E6C4B45C55D4AC' },
            keyData: {
              flags: { value: '0' },
              protocol: { value: '3' },
              alg: { value: '5' },
              pubKey: { value: '700b97b591ed27ec2590d19f06f88bba700b97b591ed27ec2590d19f' }
            }
          }
        }
      ]
    }, {
      _anonymus: [
        legalDocument: { value: 'base64', attrs: { type: 'ddoc' } }
      ]
    })

    generated = Nokogiri::XML(xml).to_s.squish
    expect(generated).to eq(expected)

  end

  it 'generates valid delete xml' do
    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <delete>
            <domain:delete
             xmlns:domain="https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/domain-eis-1.0.xsd" />
          </delete>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    generated = Nokogiri::XML(epp_xml.domain.delete).to_s.squish
    expect(generated).to eq(expected)

    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <delete>
            <domain:delete
             xmlns:domain="https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/domain-eis-1.0.xsd">
              <domain:name>one.ee</domain:name>
            </domain:delete>
          </delete>

          <extension>
            <eis:extdata xmlns:eis="https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/eis-1.0.xsd">
              <eis:legalDocument type="ddoc">base64</eis:legalDocument>
            </eis:extdata>
          </extension>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    xml = epp_xml.domain.delete({
      name: { value: 'one.ee' }
    }, {
      _anonymus: [
        legalDocument: { value: 'base64', attrs: { type: 'ddoc' } }
      ]
    })

    generated = Nokogiri::XML(xml).to_s.squish
    expect(generated).to eq(expected)
  end

  it 'generates valid renew xml' do
    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <renew>
            <domain:renew
             xmlns:domain="https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/domain-eis-1.0.xsd" />
          </renew>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    generated = Nokogiri::XML(epp_xml.domain.renew).to_s.squish
    expect(generated).to eq(expected)

    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <renew>
            <domain:renew
             xmlns:domain="https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/domain-eis-1.0.xsd">
              <domain:name>one.ee</domain:name>
              <domain:curExpDate>2009-11-15</domain:curExpDate>
              <domain:period unit="d">365</domain:period>
            </domain:renew>
          </renew>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    xml = epp_xml.domain.renew({
      name: { value: 'one.ee' },
      curExpDate: {value: '2009-11-15' },
      period: { value: '365', attrs: { unit: 'd' } }
    })

    generated = Nokogiri::XML(xml).to_s.squish
    expect(generated).to eq(expected)
  end

  it 'generates valid transfer xml' do
    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <transfer op="query">
            <domain:transfer
             xmlns:domain="https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/domain-eis-1.0.xsd" />
          </transfer>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    generated = Nokogiri::XML(epp_xml.domain.transfer).to_s.squish
    expect(generated).to eq(expected)

    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
        <command>
          <transfer op="approve">
            <domain:transfer
             xmlns:domain="https://raw.githubusercontent.com/internetee/registry/alpha/doc/schemas/domain-eis-1.0.xsd">
              <domain:name>one.ee</domain:name>
              <domain:authInfo>
                <domain:pw roid="askdf">test</domain:pw>
              </domain:authInfo>
            </domain:transfer>
          </transfer>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    xml = epp_xml.domain.transfer({
      name: { value: 'one.ee' },
      authInfo: {
        pw: { value: 'test', attrs: { roid: 'askdf' } }
      }
    }, 'approve')

    generated = Nokogiri::XML(xml).to_s.squish
    expect(generated).to eq(expected)
  end
end
