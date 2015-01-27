require 'minitest'
require 'delegate'

module Minitest
  def self.plugin_redgreen_options(opts, options)
  end

  def self.plugin_redgreen_init(options)
    io = Redgreen.new(options[:io])
    self.reporter.reporters.grep(Minitest::Reporter).each do |r|
      r.io = io
    end
  end

  class Redgreen < SimpleDelegator
    BEGIN_ESCAPE = "\e["
    END_ESCAPE = "#{BEGIN_ESCAPE}0m"
    COLORS     = { red: '31m', green: '32m', yellow: '33m', magenta: '35m' }
    STATUSES   = { '.' => :passing, 'F' => :failing, 'E' => :erring, 'S' => :skipping }

    def print(output)
      status = STATUSES[output]

      if status
        super send(status, output)
      else
        super
      end
    end

    def puts(output = nil)
      return super if output.nil?

      super output
        .gsub(/\b ((\d+) \s+ failures?) \b/x) { Integer($2) > 0 ? failing($1)  : passing($1) }
        .gsub(/\b ((\d+) \s+ errors?)   \b/x) { Integer($2) > 0 ? erring($1)   : passing($1) }
        .gsub(/\b ((\d+) \s+ skips?)    \b/x) { Integer($2) > 0 ? skipping($1) : passing($1) }
    end

    private

    def failing(output)
      colorize output, color: :red
    end

    def passing(output)
      colorize output, color: :green
    end

    def skipping(output)
      colorize output, color: :yellow
    end

    def erring(output)
      colorize output, color: :magenta
    end

    def colorize(text = nil, color:, &block)
      color = COLORS.fetch(color) do
        raise "Unknown color: known colors are #{COLORS.keys.join(', ')}"
      end

      "#{BEGIN_ESCAPE}#{color}" << (text || yield) << END_ESCAPE
    end
  end
end
