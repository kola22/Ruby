#!/bin/env ruby
# encoding: utf-8
#
# так:
require 'selenium-webdriver'
require '/opt/projects/autotest/Ruby/musthave'


books = ["Charlie and the Chocolate Factory", "War and Peace", "Utopia", "A Brief History of Time", "A Wrinkle in Time"]

# To sort our books in ascending order, in-place
#books.sort! { |firstBook, secondBook| firstBook <=> secondBook }

# Sort your books in descending order, in-place below

puts books

books.delete_if{|x| x!='War and Peace'}
puts '______'
puts books

asleep 333
class SpeedRun
    attr_accessor :t,:s
    def scanTime
        @t=@t.scan(/[\d]{1,2}/)
    end
    def speed
        self.scanTime
        sectofloat = @t[1].to_f/60
        mintofloat = @t[0].to_f+sectofloat
        mintofloat =mintofloat.round(2)

        speed = (@s/mintofloat)*60
        speed.round(2)
    end
end

tt = SpeedRun.new
tt.t ='26:20'
tt.s =4.83
 puts tt.speed

clientid = '123123'
for i in 0 .. clientid.size
    puts clientid[i]
    sleep 1 #пауза в сек
end


