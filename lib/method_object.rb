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

    # Because of the positioning of multiple params, params can never be omitted.
    def param(name, type = nil, **opts, &block)
      raise ArgumentError, "Default value for param not allowed - #{name}" if opts.key? :default
      raise ArgumentError, "Optional params not supported - #{name}" if opts.fetch(:optional, false)

      dry_initializer.param(name, type, **opts, &block)
      self
    end

    # DEPRECATED
    def assign(variable, to:)
      warn 'MethodObject.assign is deprecated. ' \
           "Please use this instead: `option #{variable.inspect}, default: ...`"
      option variable, default: to
    end

    def __check_for_unknown_options(*args)
      return if __defined_options.empty?

      opts = args.drop(__defined_params.length).first || {}
      raise ArgumentError, "Unexpected argument #{opts}" unless opts.is_a? Hash

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
