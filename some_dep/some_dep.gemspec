# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'some_dep/version'

Gem::Specification.new do |s|
  s.name          = 'some_dep'
  s.version       = SomeDep::VERSION
  s.authors       = ['Jason Penny']
  s.email         = ['jason.penny@braze.com']
  s.homepage      = 'https://github.com/braze-inc/some_dep'
  s.licenses      = []
  s.summary       = '[summary]'
  s.description   = '[description]'

  s.files         = Dir.glob('{bin/*,lib/**/*,[A-Z]*}')
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.6.0'

  s.add_dependency 'checked_deps'
end
