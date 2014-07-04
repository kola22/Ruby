#!/bin/env ruby
# encoding: utf-8


## puts "Rubydev".reverse.tap{ |o| puts "reversed: #{o}" }.upcase

require 'clipboard'


@contents = file.read

    Clipboard.copy(@contents)
a = Clipboard.paste
puts a

