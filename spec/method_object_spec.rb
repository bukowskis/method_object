require 'spec_helper'

class EmptyMethodObject
  include MethodObject
end

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

class ClassUsingAssign
  include MethodObject

  assign :example, to: proc { 'hej' }

  def call
    example
  end
end

RSpec.describe MethodObject do
  describe '.param' do
    it 'raises if defined with a default value' do
      expect do
        EmptyMethodObject.param :foo, default: ->(*) { :bar }
      end.to raise_error(SyntaxError)
    end

    it 'raises if defined as optional' do
      expect { EmptyMethodObject.param :foo, optional: true }.to raise_error(SyntaxError)
    end
  end

  describe '.call' do
    context 'when called with a block' do
      it 'passes the block to the #call method' do
        expect(ExampleMethodObject.call(an_option: 'foo')).to eq('foo')
        expect(ExampleMethodObject.call(an_option: 'foo', &:upcase)).to eq('FOO')
      end
    end

    context 'when called with unknown options' do
      it 'raises an error' do
        expect do
          ExampleMethodObject.call(an_option: 'foo', extra: 'blah')
        end.to raise_error(KeyError)
      end
    end
  end

  describe '.assign' do
    it 'adds the assigned variable as an option with a default value' do
      expect(ClassUsingAssign.call).to eq('hej')
    end
  end
end
