# frozen_string_literal: true

require 'checked_deps'

module Logger
  # Example Logger that registers itself with checked_deps
  class Printer
    def self.info(abc, efg, &blk)
      puts 'INFO', abc, efg, blk.call
    end

    def self.debug(abc, efg, &blk)
      puts 'DEBUG', abc, efg, blk.call
    end

    CheckedDeps.register(:logger) { self }
  end
end
