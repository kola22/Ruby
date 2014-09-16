#!/bin/env ruby
# encoding: utf-8
# Class names must be capitalized.  Technically, it's a constant.


# define a user class
class User
    attr_accessor :name

    def initialize(name)
        @name = name.capitalize
    end

end

# create a user object
user = User.new('Shaymol')

# this is similar to user.name, and in PHP similar to call_user_func($obj, 'methodName');
puts user.send(:name)

# => Shaymol

