require 'spec_helper'

class MinimalMethodObject
  include MethodObject

  option :color

  def call
    "The color is #{color}"
  end
end

class ExampleMethodObject
  include MethodObject

  param :shape
  option :color
  option :size, default: -> { :big }

  def call
    block_given? ? yield(to_s) : to_s
  end

  def to_s
    "#{size} #{color} #{shape}"
  end
end

RSpec.describe MethodObject do
  describe '.param' do
    context 'when defining a default value' do
      it 'raises an error' do
        expect do
          Class.new do
            include MethodObject

            param :shape, default: -> { :square }
          end
        end.to raise_error ArgumentError, /not allowed/
      end
    end

    context 'when defined as optional' do
      it 'raises an error' do
        expect do
          Class.new do
            include MethodObject

            param :user, optional: true
          end
        end.to raise_error ArgumentError, /not supported/
      end
    end

    context 'when properly defined' do
      it 'is mandatory' do
        expect do
          ExampleMethodObject.call
        end.to raise_error KeyError, /option 'color' is required/
      end
    end
  end

  describe '.call' do
    context 'without block' do
      it 'has access to options' do
        result = MinimalMethodObject.call color: 'blue'

        expect(result).to eq 'The color is blue'
      end
    end

    context 'with block' do
      it 'passes the block' do
        result = ExampleMethodObject.call('circle', color: 'blue', &:upcase)

        expect(result).to eq 'BIG BLUE CIRCLE'
      end
    end

    context 'with unknown options' do
      it 'raises an error' do
        expect do
          ExampleMethodObject.call 'square', color: 'red', ability: 'Totally invalid'
        end.to raise_error KeyError, 'Key(s) [:ability] not found in [:color, :size]'
      end
    end

    context 'without options' do
      it 'raises an error' do
        expect do
          ExampleMethodObject.call 'square', 'boom!'
        end.to raise_error ArgumentError, 'Unexpected argument boom!'
      end
    end
  end
end
