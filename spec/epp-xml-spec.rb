require 'active_support/core_ext/string/filters'
require 'nokogiri'
require 'active_support'
require 'epp-xml'

describe EppXml do
  it 'generates valid login xml' do
    expected = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <epp xmlns="urn:ietf:params:xml:ns:epp-1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '\
      'xsi:schemaLocation="urn:ietf:params:xml:ns:epp-1.0 epp-1.0.xsd">
        <command>
          <login>
            <clID>user</clID>
            <pw>pw</pw>
            <options>
              <version>1.0</version>
              <lang>en</lang>
            </options>
            <svcs>
              <objURI>urn:ietf:params:xml:ns:contact-1.0</objURI>
            </svcs>
          </login>
          <clTRID>ABC-12345</clTRID>
        </command>
      </epp>
    ').to_s.squish

    generated = Nokogiri::XML(EppXml.login).to_s.squish
    expect(generated).to eq(expected)
  end

  context 'in context of Domain' do

  end
end
