#!/bin/env ruby
# encoding: utf-8
#
# так:
def time2x
    time = Time.now.strftime('%d-%m-%Y %H-%M-%S')
end

#дата
def date
    date = time2x[0, 10]
end

def strstst
    zzzz =  '02021021030219310293812098310283103'
end


def sssss
    qa = strstst[0,3]
end


puts "#{Time.now.day}.#{Time.now.month}.#{Time.now.year} - #{Time.now.day}.#{Time.now.month}.#{Time.now.year}"
a = Time.now
puts a

puts a[0,10]


## dateRange=04.02.2015