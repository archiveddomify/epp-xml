Gem::Specification.new do |s|
  s.name        = 'epp-xml'
  s.version     = '0.0.1'
  s.date        = '2014-10-22'
  s.summary     = 'Gem for generating XML for EPP requests'
  s.authors     = ['Gitlab LTD']
  s.email       = 'enquiries@gitlab.eu'
  s.files       = ['lib/epp-xml.rb']
  s.require_paths = ['lib']
  s.license       = 'MIT'

  s.add_dependency 'activesupport', '~> 4.1', '>= 4.1.4'

  s.add_runtime_dependency 'builder', '~> 3.2', '>= 3.2.2'

  s.add_development_dependency 'rspec', '~> 3.1'
  s.add_development_dependency 'nokogiri', '~> 1.6'
end

