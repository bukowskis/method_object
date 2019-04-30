require 'dry-initializer'

module MethodObject
  def self.included(base)
    base.extend Dry::Initializer
    base.extend ClassMethods
    base.send(:private_class_method, :new)
  end

  module ClassMethods
    def call(*args, &block)
      __check_for_unknown_options(*args)
      new(*args).call(&block)
    end

    def __check_for_unknown_options(*args)
      return if __defined_options.empty?

      opts = args.drop(__defined_params.length).first || {}
      raise ArgumentError, "Unexpected argument #{opts}" unless opts.is_a? Hash

      unknown_options = opts.keys - __defined_options
      raise KeyError, "Key(s) #{unknown_options} not found in #{__defined_options}" if unknown_options.any?
    end

    def __defined_options
      dry_initializer.options.map(&:source)
    end

    def __defined_params
      dry_initializer.params.map(&:source)
    end

    def param(name, type = nil, **opts, &block)
      raise SyntaxError, "Default value for param is not allowed - #{name}" if opts.key? :default
      raise SyntaxError, "Optional params is not supported - #{name}" if opts.fetch(:optional, false)

      dry_initializer.param(name, type, **opts, &block)
      self
    end

    def assign(variable, to:)
      option variable, default: to
    end
  end
end
