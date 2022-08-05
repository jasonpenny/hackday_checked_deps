# frozen_string_literal: true

require 'dry-container'
require 'dry-auto_inject'

require 'checked_deps/errors'
require 'checked_deps/version'
require 'checked_deps/method_definition'

# Dependency Injection with method and argument validation
module CheckedDeps
  extend Dry::Container::Mixin

  INJECT = Dry::AutoInject(CheckedDeps)
  # private_constant :INJECT

  def self.depend_on(klass, dependencies, auto_inject: true)
    klass.include INJECT[*dependencies.keys] if auto_inject

    @dependency_methods ||= {}
    dependencies.each do |dependency, method_defs|
      @dependency_methods[dependency] ||= {}
      @dependency_methods[dependency][klass] = method_defs
    end
  end

  def self.validate_dependencies!
    return if @dependency_methods.nil?

    @dependency_methods.each do |dependency, klass_and_method_defs|
      klass_and_method_defs.each do |klass, method_defs|
        method_defs.each do |method_def|
          validate_dependency(klass, instance: resolve(dependency), method_def: method_def)
        end
      end
    end

    # Allow this to be garbage-collected, we should no longer need this data
    @dependency_methods = nil
  end

  private_class_method def self.validate_dependency(klass, instance:, method_def:)
    actual_param_types = method_parameter_types(instance, method_def)

    return if method_def.param_types == actual_param_types

    raise CheckedDeps::WrongArgumentsError,
          "#{klass} : #{instance}##{method_def.name} " \
          "wants arguments #{method_def.param_types} but receives #{actual_param_types}"
  end

  def self.method_parameter_types(instance, method_def)
    instance.public_method(method_def.name).parameters.map { _1[0] }
  rescue NameError
    raise CheckedDeps::MissingMethodError, "#{instance}##{method_def.name} does not exist"
  end
end
