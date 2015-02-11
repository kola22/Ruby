#!/bin/env ruby
# encoding: utf-8
#
# так:

class SpeedRun
    attr_accessor :t,:s
    def scanTime
        @t=@t.scan(/[\d]{1,2}/)
    end
    def speed
        self.scanTime
        # sectofloat = @t[1].to_f*1.66
        sectofloat = @t[1].to_f/60
        mintofloat = @t[0].to_f+sectofloat
        mintofloat =mintofloat.round(2)

        speed = (@s/mintofloat)*60
        speed.round(2)
    end
end

tt = SpeedRun.new
tt.t ='31:35'
tt.s =4.83
# puts tt.speed


def mt op
    op*op
end

def bbb z1z1z1
    z1z1z1*z1z1z1
end

zzz = bbb(mt(2))
puts zzz #16


