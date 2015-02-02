#!/bin/env ruby
# encoding: utf-8
#
class Monkey
    def initialize(height, weight)
        @height = height
        @weight = weight
    end

    def height
        @height
    end

    def weight
        @weight
    end

    def height=(height)
        @height = height
    end

    def weight=(weight)
        @weight = weight
    end
end

class Human < Monkey
    def initialize(height, weight, name)
        super(height, weight)
        @name = name
    end

    def name
        @name
    end

    def name=(name)
        @name = name
    end
end

class BlackHuman < Human

    class << self
        def obj_count
            count = 0
            ObjectSpace.each_object(self){|obj| count += 1}
        end
    end

    def initialize(height, weight, name)
        super(height, weight, name)
        @skin_color = :black
    end

    def skin_color
        @skin_color
    end

    def skin_color=(skin_color)
        @skin_color = skin_color
    end
end

bh = BlackHuman.new(180,90,"John")
bh2 = BlackHuman.new(185,90,"Robert")
bh3 = BlackHuman.new(170,70,"Thomas")

puts BlackHuman.obj_count # 3


















