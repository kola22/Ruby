#!/bin/env ruby
# encoding: utf-8

require 'selenium-webdriver'
require 'nokogiri'
require 'open-uri'
require 'clipboard'

x = 'http://piletskiy.abcp.ru.lan/?tlogin=2222@222.ruw&authCode=4b0845a6cb5a2209cd57adb10b07e7ed'
if x.match(/.landdddd\W{2}/) == false
    puts '3333'
end
