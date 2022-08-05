# frozen_string_literal: true

require 'checked_deps'

module SomeDep
  # A class that autoinjects the registered logger
  class DependencyUser
    include CheckedDeps::INJECT[:logger]

    def example_call
      # injected instance var @logger
      logger.info('abc', 'def') { 'block' }
    end

    def self.self_example_call
      # not injected to the class, so use CheckedDeps.resolve() or CheckedDeps[]
      CheckedDeps[:logger].debug('abc', 'def') { 'block' }
    end
  end
end
