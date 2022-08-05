# frozen_string_literal: true

require 'checked_deps'

module Some
  # Example Logger that registers itself with checked_deps
  class Logger
    def self.info(abc, efg, &blk)
      puts abc, efg, blk.call
    end

    def self.debug(str)
      puts str
    end

    CheckedDeps.register(:logger) { self }
  end
end
