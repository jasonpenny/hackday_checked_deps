# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'checked_deps/version'

Gem::Specification.new do |s|
  s.name          = 'checked_deps'
  s.version       = CheckedDeps::VERSION
  s.authors       = ['Jason Penny']
  s.email         = ['jason.penny@braze.com']
  s.homepage      = 'https://github.com/jasonpenny/checked_deps'
  s.licenses      = ['MIT']
  s.summary       = '[summary]'
  s.description   = '[description]'

  s.files         = Dir.glob('{bin/*,lib/**/*,[A-Z]*}')
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.6.0'

  s.add_dependency 'dry-auto_inject'
  s.add_dependency 'dry-container'
end
