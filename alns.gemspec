# frozen_string_literal: true

require './lib/alns/version'

ALNS::GEMSPEC = Gem::Specification.new do |s|
  s.name          = 'alns'
  s.version       = ALNS::VERSION
  s.summary       = 'Adaptive Large Neighbourhood Search'
  s.authors       = ['bibenga']
  s.email         = 'bibenga@users.noreply.github.com'
  s.files         = Dir['LICENSE', 'lib/**/*.rb']
  s.require_paths = ['lib']
  s.homepage      = 'https://github.com/bibenga/alns-ruby'
  s.metadata      = { 'source_code_uri' => 'https://github.com/bibenga/alns-ruby' }
  s.license       = 'MIT'
  s.required_ruby_version = '>= 3.4'
end
