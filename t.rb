# frozen_string_literal: true

require 'dry-container'
require 'dry-auto_inject'

# BrazeDeps dependency container and injection
# with method+signature checking
module BrazeDeps
  class MissingMethodError < StandardError; end
  class WrongArgumentsError < StandardError; end

  # Helps to define a method with a name and param_types
  class MethodDefinition
    attr_accessor :name, :param_types

    def initialize(name, param_types: [])
      @name = name
      @param_types = param_types
    end
  end

  extend Dry::Container::Mixin

  INJECT = Dry::AutoInject(BrazeDeps)
  private_constant :INJECT

  def self.depend_on(klass, dependencies)
    klass.include INJECT[*dependencies.keys]

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
  end

  private_class_method def self.validate_dependency(klass, instance:, method_def:)
    actual_param_types = method_parameter_types(instance, method_def)

    return if method_def.param_types == actual_param_types

    raise BrazeDeps::WrongArgumentsError,
          "#{klass} : #{instance}##{method_def.name} " \
          "wants arguments #{method_def.param_types} but receives #{actual_param_types}"
  end

  def self.method_parameter_types(instance, method_def)
    instance.public_method(method_def.name).parameters.map { _1[0] }
  rescue NameError
    raise BrazeDeps::MissingMethodError, "#{instance}##{method_def.name} does not exist"
  end
end

module Other
  # A class to autoinject the registered logger
  class DependencyUser
    BrazeDeps.depend_on(
      self,
      {
        logger: [
          BrazeDeps::MethodDefinition.new(:info, param_types: %i[req req block]),
          BrazeDeps::MethodDefinition.new(:debug, param_types: %i[req])
        ]
      }
    )

    def call
      # injected ivar @logger by calling BrazeDeps.depend_on()
      logger.info('abc', 'def') { 'block' }
    end

    def self.self_call
      # not injected to the class, so use BrazeDeps.resolve() or BrazeDeps[]
      BrazeDeps[:logger].info('abc', 'def') { 'block' }
    end
  end
end

module Jason
  # Logger to be injected
  class Logger
    def self.info(abc, efg, &blk)
      puts abc, efg, blk.call
    end

    def self.debug(str); end

    BrazeDeps.register(:logger) { self }
  end
end

BrazeDeps.validate_dependencies!

Other::DependencyUser.self_call
puts
Other::DependencyUser.new.call
