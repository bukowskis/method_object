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

    def __check_for_unknown_options(*_, **options)
      return if self.dry_initializer.options.empty?

      source_keys = dry_initializer.options.map(&:source)
      unknown_keys = options.keys - source_keys
      raise KeyError, "Key(s) #{unknown_keys} not found in #{source_keys}" if unknown_keys.any?
    end

    def assign(variable, to:)
      option variable, default: to
    end
  end
end
