#!/bin/env ruby
# encoding: utf-8
# Class names must be capitalized.  Technically, it's a constant.

def foo
    puts yield # выполняем блок
    puts yield + yield # и еще, и еще выполняем
end
foo { 2 } # 2 4
def bar(&block) # или, если поменьше пудры
    puts yield block # выполняем блок
end
bar { 3 } # 3
