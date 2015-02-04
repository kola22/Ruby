#!/bin/env ruby
# encoding: utf-8
#

class Driver22
    attr_accessor :a,:b
    def initialize a=1,b=2,c=3
        @a=a
        @b=b
        @c=c
    end
    def putsXs
        puts @a,@b,@c
    end
end


qub = Driver22.new
qub.putsXs # 1,2,3
qub.a = 777
qub.putsXs # 777,2,3

puts '__________'
class NewDrive < Driver22
    attr_accessor :c
    attr_accessor :d
    def initialize a,b,c,d
        super a,b,c
        @d = d
    end
    def putsXs
        super
        puts @d
    end
end

op = NewDrive.new 3,4,5,6
op.putsXs # 3,4,5,6
op.c = 999
op.putsXs # 3,4,999,6
op.d = '000'
op.putsXs # 3,4,999,000
puts op.d














