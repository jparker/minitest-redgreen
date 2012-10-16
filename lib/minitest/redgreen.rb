require 'minitest/unit'
require 'minitest/redgreen/version'

module MiniTest
  class Redgreen
    BEGIN_ESCAPE = "\e["
    END_ESCAPE = "#{BEGIN_ESCAPE}0m"

    attr_reader :io

    def initialize(io)
      @io = io
    end

    def print(o)
      case o
      when '.' then
        io.print passing(o)
      when 'E', 'F'
        io.print failing(o)
      when 'S'
        io.print pending(o)
      else
        io.print o
      end
    end

    def puts(*o)
      o.map! do |s|
        s.gsub(/\b((?:\d+)\s+(?:error|failure)s?)/) {
          colorize_summary $1, :failing
        }.sub(/\b((?:\d+)\s+skips?)/) {
          colorize_summary $1, :pending
        }
      end
      super
    end

    private
    def failing(o)
      "#{BEGIN_ESCAPE}31m#{o}#{END_ESCAPE}"
    end

    def passing(o)
      "#{BEGIN_ESCAPE}32m#{o}#{END_ESCAPE}"
    end

    def pending(o)
      "#{BEGIN_ESCAPE}33m#{o}#{END_ESCAPE}"
    end

    def colorize_summary(text, highlighter)
      match = text.match(/(\d+)\s+\w+/)
      if match && match[1].to_i > 0
        send highlighter, match[0]
      else
        passing match[0]
      end
    end
  end
end

MiniTest::Unit.output = MiniTest::Redgreen.new(MiniTest::Unit.output)
