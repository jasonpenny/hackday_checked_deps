# frozen_string_literal: true

module Other
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

    def call
      # injected ivar @logger by calling CheckedDeps.depend_on()
      logger.info('abc', 'def') { 'block' }
    end

    def self.self_call
      # not injected to the class, so use CheckedDeps.resolve() or CheckedDeps[]
      CheckedDeps[:logger].info('abc', 'def') { 'block' }
    end
  end
end
