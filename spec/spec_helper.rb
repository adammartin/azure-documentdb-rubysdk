require 'gimme'
require 'simplecov'

def no_methods_called_on_object a_test_double
  verification = verify(a_test_double, 0)
  (verification.__gimme__cls.instance_methods - Object.methods).each do |method_name|
    method = verification.__gimme__cls.instance_method method_name
    verification.send method_name, *(Array.new method.arity, anything)
  end
end

SimpleCov.start do
  add_filter "/spec/"
end

module Gimme
  class MultiCaptor
    attr_reader :values

    def values
      @values ||= []
    end

    def value
      values.last
    end

    def value= arg
      values << arg
    end

    private
    attr_writer :values
  end
end

module MyMatchers
  def verify_never test_double
    verify(test_double, 0)
  end

  def verify_never! test_double
    verify!(test_double, 0)
  end
end

RSpec.configure do |config|
  config.mock_framework = Gimme::RSpecAdapter
  config.include MyMatchers
end
