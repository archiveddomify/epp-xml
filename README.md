EPP XML
===============
This gem is for generating EPP (Extensible Provisioning Protocol) XML. 
Note that this gem does not validate generated XML against EPP schemas. The gem merely offers tools to ease the difficulty of building XML.

## Installation

Add this to your Gemfile:

```ruby
gem 'epp-xml'
```

Then bundle:

```bash
% bundle
```

## Usage

Majority of the methods take a specifically formatted hash as an input.
The element consists of its name (key in hash), `value` and 0..n `attrs`.
Note that you can nest elements in one another (`authInfo`):

```ruby
epp_xml = EppXml::Domain.new(cl_trid_prefix: 'ABC')
xml = epp_xml.info({
  name: { value: 'one.ee', attrs: { hosts: 'sub' } },
  authInfo: {
    pw: { value: 'b3rafsla' }
  }
})

puts Nokogiri(xml)
```

Results in:

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
  <command>
    <info>
      <domain:info xmlns:domain="urn:ietf:params:xml:ns:domain-1.0">
        <domain:name hosts="sub">one.ee</domain:name>
        <domain:authInfo>
          <domain:pw>b3rafsla</domain:pw>
        </domain:authInfo>
      </domain:info>
    </info>
    <clTRID>ABC-12345</clTRID>
  </command>
</epp>
```

When you have multiple elements with same name, you have to wrap these elements into an array.
Note the `_anonymus` key. Any key that starts with and underscore will not be turned into element itself:

```ruby
epp_xml = EppXml::Domain.new(cl_trid_prefix: 'ABC')
xml = epp_xml.check({
  _anonymus: [
    { name: { value: 'example.ee' } },
    { name: { value: 'example2.ee' } },
    { name: { value: 'example3.ee' } }
  ]
})

puts Nokogiri(xml)
```

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
  <command>
    <check>
      <domain:check xmlns:domain="urn:ietf:params:xml:ns:domain-1.0">
        <domain:name>example.ee</domain:name>
        <domain:name>example2.ee</domain:name>
        <domain:name>example3.ee</domain:name>
      </domain:check>
    </check>
    <clTRID>ABC-12345</clTRID>
  </command>
</epp>
```

If you still need to create the element and provide it with an attibute as well, then you can do something like this (note `postalInfo` and `disclose`)

```ruby
epp_xml = EppXml::Contact.new(cl_trid_prefix: 'ABC')
xml = epp_xml.create({
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

puts Nokogiri(xml)
```

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
  <command>
    <create>
      <contact:create xmlns:contact="urn:ietf:params:xml:ns:contact-1.0">
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
```

Some methods take multiple arguments (eg. EppXml::Domain.create), refer to tests to see more examples.
