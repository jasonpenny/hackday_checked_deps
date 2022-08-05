# frozen_string_literal: true

require 'checked_deps'

require './some/logger'
require './other/dependency_user'

CheckedDeps.validate_dependencies!

puts 'Dependency resolution from a class method'
Other::DependencyUser.new.call
puts '', 'Dependency Injection on an instantiated object'
Other::DependencyUser.new.call
