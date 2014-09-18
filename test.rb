#!/bin/env ruby
# encoding: utf-8
# Class names must be capitalized.  Technically, it's a constant.

a=gets
c=gets.chomp
c=c.to_s
a=a.to_f
b=gets
b=b.to_f

def calc a,b,c=false
    if c =='+'
        puts a+b
    elsif c=='*'
        puts a*b
    elsif c=='/'
        puts a/b
    end

end

calc a,b,c