MethodObject
==============
[![Maintainability](https://api.codeclimate.com/v1/badges/55b133b2c8e1a9649d88/maintainability)](https://codeclimate.com/repos/5c8032b7c1be5c599400eedd/maintainability)
[![CircleCI](https://circleci.com/gh/bukowskis/method_object.svg?style=shield)](https://circleci.com/gh/bukowskis/method_object)

A little module to simplify creating method objects / service classes.
Classes using this module gets a .call class-method that instantiates the class and calls the instance method #call.

## Usage

````ruby
class SaySomething
  include MethodObject
  
  option :text
  
  def call
    puts text
  end
end

SaySomething.call(text: 'Hi there!') # => 'Hi there!'
````

It uses dry-initializer for options and params. See http://dry-rb.org/gems/dry-initializer/ for more information.
