#!/bin/env ruby
# encoding: utf-8


## puts "Rubydev".reverse.tap{ |o| puts "reversed: #{o}" }.upcase

def method
    10 / 0

rescue
    puts 'Fuck! Divider is zero!'
end

method