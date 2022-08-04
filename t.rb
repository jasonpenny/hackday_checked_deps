# frozen_string_literal: true

require 'byebug'
require 'dry-container'
require 'dry-auto_inject'

# BrazeDeps dependency container and injection
# with method+signature checking
module BrazeDeps
  # Error to be raised in validate_dependencies! if expectation is not met
  class DependencyError < StandardError
    def initialize(klass, instance, method, actual_params, dependant_params)
      super("DependencyError in #{klass} : #{instance}##{method} wants params #{dependant_params} but receives #{actual_params}")
    end
  end

  extend Dry::Container::Mixin

  INJECT = Dry::AutoInject(BrazeDeps)

  def self.depend_on(klass, dependencies_hash)
    klass.include INJECT[*dependencies_hash.keys]

    @dependency_methods ||= {}
    dependencies_hash.each do |dependency, methods_and_params|
      methods_and_params.each do |method, params|
        @dependency_methods[dependency] ||= {}
        @dependency_methods[dependency][method] ||= {}
        @dependency_methods[dependency][method][klass] = params
      end
    end
  end

  def self.validate_dependencies!
    return if @dependency_methods.nil?

    @dependency_methods.each do |dependency, methods_and_klasses|
      methods_and_klasses.each do |method, klasses_and_params|
        validate_dependency(klasses_and_params, instance: resolve(dependency), method: method)
      end
    end
  end

  private_class_method def self.validate_dependency(klasses_and_params, instance:, method:)
    actual_params = method_parameter_types(instance, method)

    klasses_and_params.each do |klass, params|
      raise BrazeDeps::DependencyError.new(klass, instance, method, actual_params, params) if params != actual_params
    end
  end

  def self.method_parameter_types(instance, method_name)
    instance.public_method(method_name).parameters.map { _1[0] }
  end
end

module Other
  # A class to autoinject the registered logger
  class DependencyUser
    BrazeDeps.depend_on(
      self,
      {
        # TODO : maybe syntactical sugar for BrazeDeps::MethodDefinition(info, %i[rest block])
        logger: { info: %i[req req block] }
      }
    )

    def call
      logger.info('abc', 'def') { 'block' }
    end

    def self.self_call
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
    BrazeDeps.register(:logger) { self }
  end
end

BrazeDeps.validate_dependencies!

Other::DependencyUser.self_call
puts
Other::DependencyUser.new.call
