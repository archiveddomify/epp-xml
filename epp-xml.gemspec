Gem::Specification.new do |s|
  s.name        = 'epp-xml'
  s.version     = '1.0.4'
  s.date        = '2015-07-24'
  s.summary     = 'Gem for generating XML for EIS EPP requests'
  s.description = 'Gem for generating valid XML for EIS Extensible Provisioning Protocol requests'
  s.authors     = ['GiTLAB LTD']
  s.email       = 'info@gitlab.eu'
  s.files       = ['lib/epp-xml.rb', 'lib/client_transaction_id.rb', 'lib/epp-xml/domain.rb', 'lib/epp-xml/contact.rb', 'lib/epp-xml/session.rb', 'lib/epp-xml/keyrelay.rb']
  s.require_paths = ['lib']
  s.license       = 'MIT'
  s.homepage    = 'https://github.com/gitlabeu/epp-xml'

  s.add_dependency 'activesupport', '~> 4.1'

  s.add_runtime_dependency 'builder', '~> 3.2'

  s.add_development_dependency 'rspec', '~> 3.1'
  s.add_development_dependency 'nokogiri', '~> 1.6'

  s.required_ruby_version = '~> 2.2'
end
