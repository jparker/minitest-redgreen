require 'minitest/autorun'
require 'minitest/redgreen'
require 'stringio'

class TestMiniTestRedgreen < MiniTest::Unit::TestCase
  def test_passing
    output = print('.')
    assert_equal "\e[32m.\e[0m", output, "'#{output.inspect}' should be a green '.'"
  end

  def test_failing
    output = print('F')
    assert_equal "\e[31mF\e[0m", output, "'#{output.inspect}' should be a red 'F'"
  end

  def test_error
    output = print('E')
    assert_equal "\e[31mE\e[0m", output, "'#{output.inspect}' should be a red 'E'"
  end

  def test_skipping
    output = print('S')
    assert_equal "\e[33mS\e[0m", output, "'#{output.inspect}' should be a yellow 'S'"
  end

  private
  def print(str)
    StringIO.new.tap do |iostream|
      MiniTest::Redgreen.new(iostream).print(str)
      iostream.rewind
    end.read
  end
end
