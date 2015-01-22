#!/bin/env ruby
# encoding: utf-8
#

class Top
       puts "Новый подкласс"

    def qa
        puts 'qa'
    end
end

class Middle < Top
    puts "Наследователь"
end

inherit = Middle.new
inherit



# a = Top.new
# a.qa



class Bottom < Middle
end