# MethodObject

[![Version](https://img.shields.io/gem/v/method_object)](https://github.com/bukowskis/method_object.svg/releases)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/bukowskis/method_object/blob/master/LICENSE.md)
[![Build Status](https://circleci.com/gh/bukowskis/method_object.svg?style=shield)](https://circleci.com/gh/bukowskis/method_object)
[![Maintainability](https://api.codeclimate.com/v1/badges/55b133b2c8e1a9649d88/maintainability)](https://codeclimate.com/repos/5c8032b7c1be5c599400eedd/maintainability)

### TL; DR

The [method object pattern](https://refactoring.guru/replace-method-with-method-object) implies that you have one Ruby class for one single thing you want to perform.

This gem helps you to do just that with minimal overhead. The convention is to use the `.call` class method like so:

```ruby
class SaySometing
  include MethodObject
  
  # Input
  option :text
  
  # Output
  def call
    puts text
  end
end

SaySometihng.call(text: 'Hi there!') # => 'Hi there!'
```

## Rationale

A minimal implementation of the method object pattern would probably look [like this](https://github.com/deadlyicon/method_object/blob/16944f7088bbe4d9e0039688077b91fdd4adcdbd/lib/method_object.rb). This is sometimes also referred to as "service class".

```ruby
class SaySometing
  def self.call(*args, &block)
    new.call(*args, &block)
  end
  
  def call(text)
    puts text
  end
end
```

> Fun fact: [previously](https://github.com/deadlyicon/method_object/issues/3) that was actually the implementation of this gem.

Basically everything passed to `MyClass.call(...)` would be passed on to `MyClass.new.call(...)`. 

Even better still, it *should* be passed on to `MyClass.new(...).call` so that your implementation becomes cleaner:

```ruby
class SaySometing
  def self.call(*args, &block)
    new(*args, &block).call
  end
  
  def initialize(text:)
    @text = text
  end
  
  def call
    puts @text
  end
end
```


People [implemented that](https://github.com/LIQIDTechnology/methodobject/blob/89ba022d61ac6037564cc1056c00813375a2d3ae/lib/method_object.rb#L73-L75), but in doing so reinvented the wheel. Because now you not only have the method object pattern (i.e. `call`), now you also have to deal with initialization (i.e. `new`).

That's where the popular [dry-initializer](https://dry-rb.org/gems/dry-initializer) gem comes in. It is a battle-tested way to initialize objects with mandatory and optional attributes.

The `method_object` gem (you're looking at it right now), combines both the method object pattern and dry initialization.

## Installation

```
# Add this to your Gemfile
gem 'method_object`
```

## Usage

If you only have one mandatory, obvious argument, this is what your implementation most likely would look like:

```ruby
class CalculateTax
  include MethodObject
  
  param :product
  
  def call
    product.price * 0.1
  end
end

bike = Bike.new(price: 50)
CalculateTax.call(bike) # => 5
```

If you prefer to use named keywords, use this instead:

````ruby
class CalculateTax
  include MethodObject
  
  option :product
  
  def call
    product.price * 0.1
  end
end

bike = Bike.new(price: 50)
CalculateTax.call(product: bike) # => 5
````

You can also use both params and options. They are all mandatory.

````ruby
class CalculateTax
  include MethodObject
  
  param :product
  option :dutyfree
  
  def call
    return 0 if dutyfree
    product.price * 0.1
  end
end

bike = Bike.new(price: 50)
CalculateTax.call(bike, dutyfree: true) # => 0
````

You can make options optional by defining a default value in a proc:

````ruby
class CalculateTax
  include MethodObject
  
  param :product
  option :dutyfree, default: -> { false }
  
  def call
    return 0 if dutyfree
    product.price * 0.1
  end
end

bike = Bike.new(price: 50)
CalculateTax.call(bike) # => 5
````

That's it! 

# Caveats

* `params` cannot be optional (or have default values). This is because there can be several params in a row, which leads to confusion when they are optional.

# Thanks

* A big thank you to [Jared](https://github.com/deadlyicon) who was so kind to give us the `method_object` gem name for our implementation.
* The [dry-rb](https://dry-rb.org/) team for their sense of beauty.

# License

MIT License, see [LICENSE.md](https://github.com/bukowskis/method_object/blob/master/LICENSE.md)
