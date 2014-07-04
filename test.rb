#!/bin/env ruby
# encoding: utf-8


## puts "Rubydev".reverse.tap{ |o| puts "reversed: #{o}" }.upcase

require 'clipboard'


file = File.open('out_15:26_3_July.txt', "rb:UTF-8")
@contents = file.read

    Clipboard.copy(@contents)
a = Clipboard.paste
puts a

