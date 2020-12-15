require 'dry-initializer'

module MethodObject
  def self.included(base)
    base.extend Dry::Initializer
    base.extend ClassMethods
    base.send(:private_class_method, :new)
  end

  module ClassMethods
    def call(*args, **kwargs, &block)
      __check_for_unknown_options(*args, **kwargs)

      if kwargs.empty?
        # Preventing `Passing the keyword argument as the last hash parameter is deprecated`
        new(args).call(&block)
      else
        new(*args, **kwargs).call(&block)
      end
    end

    # Overriding the implementation of `#param` in the `dry-initializer` gem.
    # Because of the positioning of multiple params, params can never be omitted in a method object.
    def param(name, type = nil, **opts, &block)
      raise ArgumentError, "Default value for param not allowed - #{name}" if opts.key? :default
      raise ArgumentError, "Optional params not supported - #{name}" if opts.fetch(:optional, false)

      super
    end

    def __check_for_unknown_options(*args, **kwargs)
      return if __defined_options.empty?

      # Checking params
      opts = args.drop(__defined_params.length).first || kwargs
      raise ArgumentError, "Unexpected argument #{opts}" unless opts.is_a? Hash

      # Checking options
      unknown_options = opts.keys - __defined_options
      message = "Key(s) #{unknown_options} not found in #{__defined_options}"
      raise KeyError, message if unknown_options.any?
    end

    def __defined_options
      dry_initializer.options.map(&:source)
    end

    def __defined_params
      dry_initializer.params.map(&:source)
    end
  end
end
