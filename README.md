# MethodObject

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
