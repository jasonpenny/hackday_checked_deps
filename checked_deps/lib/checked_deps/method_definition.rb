# frozen_string_literal: true

module CheckedDeps
  # Helps to define a method with a name and param_types
  class MethodDefinition
    attr_accessor :name, :param_types

    def initialize(name, param_types: [])
      @name = name
      @param_types = param_types
    end
  end
end
