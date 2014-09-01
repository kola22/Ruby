#!/bin/env ruby
# encoding: utf-8


# Class names must be capitalized.  Technically, it's a constant.

class Coffe
    def make_coffee
         puts 'Do it'
    end
end

class Capuchino < Coffe
    def createMilk x
        prepare x
        pusht
    end

    private
    def prepare x333
        puts 'Делаем молочише'
        puts x333
    end
    def pusht
        puts 'PUSH'
    end
end


saeco = Capuchino.new
saeco.make_coffee
saeco.createMilk 5456
###

S  = 6.11
t = 39.32
speed = S/t * 60

puts speed






