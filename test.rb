#!/bin/env ruby
# encoding: utf-8


## puts "Rubydev".reverse.tap{ |o| puts "reversed: #{o}" }.upcase

my_number = 123
puts "В двоичном виде: %b" % my_number #=> В двоичном виде: 1111011

gets

def method_with_block(hello)
    yield(hello)
end
method_with_block("Hello!"){|msg| puts 'dsfsdfsdfsfsdfsdfsdf'+msg} #Hello
gets

def twice
 x = 66
 y = 666
 z =4
        yield z
end

twice { |d| if d>3
    puts d
end}

