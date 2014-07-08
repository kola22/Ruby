#!/bin/env ruby
# encoding: utf-8

## puts "Rubydev".reverse.tap{ |o| puts "reversed: #{o}" }.upcase

aa = 'LJD_PleaseDelMeBro_2014-07-08 09:12:21'
##aa = 'LJD_PleaseDelMeBro_2014-07-08 09:12:21'.match(/([A-z]{1,})/)

ii=aa.match(/([A-z]{1,})/)
puts ii