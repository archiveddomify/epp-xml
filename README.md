EPP XML
===============
This gem is for generating valid EPP (Extensible Provisioning Protocol) XML.

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

Majority of the methods take a specifically formatted hash as an input

```ruby
xml = EppXml::Domain.info({
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
