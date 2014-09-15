#!/bin/env ruby
# encoding: utf-8
# Class names must be capitalized.  Technically, it's a constant.

def function
    "I am #{self}, of class #{self.class}"
end

puts function # => "I am main, of class Object"

puts Object.private_instance_methods.grep(/function/) # => [:function]


