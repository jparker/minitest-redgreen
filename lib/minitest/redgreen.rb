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
      when 'F'
        io.print failing(o)
      when 'E'
        io.print erring(o)
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

    def failing(o); escape('31m') {o}; end
    def passing(o); escape('32m') {o}; end
    def pending(o); escape('33m') {o}; end
    def erring(o);  escape('35m') {o}; end

    def escape(sequence)
      "\e[#{sequence}" << yield << "\e[0m"
    end

    def colorize_summary(text, highlighter)
      match = text.match(/(\d+)\s+(\w+)/)
      if match && match[1].to_i > 0
        case match[2]
        when 'errors', 'failures'
          failing match[0]
        when 'skips'
          pending match[0]
        end
      else
        passing match[0]
      end
    end
  end
end

MiniTest::Unit.output = MiniTest::Redgreen.new(MiniTest::Unit.output)
