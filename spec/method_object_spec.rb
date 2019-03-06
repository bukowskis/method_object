require 'spec_helper'

class ExampleMethodObject
  include MethodObject

  option :an_option

  def call
    if block_given?
      yield an_option
    else
      an_option
    end
  end
end

RSpec.describe MethodObject do
  describe '.call' do
    context 'when called with a block' do
      it 'passes the block to the #call method' do
        expect(ExampleMethodObject.call(an_option: 'foo')).to eq('foo')
        expect(ExampleMethodObject.call(an_option: 'foo', &:upcase)).to eq('FOO')
      end
    end
  end

  describe '.assign' do
    class ClassUsingAssign
      include MethodObject

      assign :example, to: proc { "hej" }

      def call
        example
      end
    end

    it 'adds the assigned variable as an option with a default value' do
      expect(ClassUsingAssign.call).to eq('hej')
    end
  end
end
