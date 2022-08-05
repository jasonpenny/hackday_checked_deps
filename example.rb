# frozen_string_literal: true

require 'bundler/inline'
gemfile do
  source 'https://rubygems.org'
  gem 'checked_deps', path: './checked_deps'

  gem 'logger', path: './logger'
  gem 'some_dep', path: './some_dep'
end

puts '----------------------------------------------'
puts 'Dependency Injection on an instantiated object'
puts '----------------------------------------------'
SomeDep::DependencyUser.new.example_call

puts '----------------------------------------------'
puts 'Dependency resolution from a class method'
puts '----------------------------------------------'
SomeDep::DependencyUser.self_example_call
