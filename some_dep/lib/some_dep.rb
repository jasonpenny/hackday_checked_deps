# frozen_string_literal: true

require 'checked_deps'

module SomeDep
  # A class that autoinjects the registered logger
  class DependencyUser
    CheckedDeps.depend_on(
      self,
      {
        logger: [
          CheckedDeps::MethodDefinition.new(:info, param_types: %i[req req block]),
          CheckedDeps::MethodDefinition.new(:debug, param_types: %i[req])
        ]
      }
    )

    def example_call
      # injected instance var @logger
      logger.info('abc', 'def') { 'block' }
    end

    def self.self_example_call
      # not injected to the class, so use CheckedDeps.resolve() or CheckedDeps[]
      CheckedDeps[:logger].debug("abc\ndef\nblock")
    end
  end
end
