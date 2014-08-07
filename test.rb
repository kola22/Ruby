#!/bin/env ruby
# encoding: utf-8

require 'selenium-webdriver'
require 'nokogiri'
require 'open-uri'
require 'clipboard'

x=0
printing_page = Nokogiri::HTML(open("http://rp5.ru/%D0%9F%D0%BE%D0%B3%D0%BE%D0%B4%D0%B0_%D0%B2_%D0%A2%D0%B0%D0%B3%D0%B0%D0%BD%D1%80%D0%BE%D0%B3%D0%B5"))
best_price = printing_page.css('span b')[0]  # This is a overly simple finder. Nokogiri can do xpath searches too.
best_price = best_price.text
##puts best_price
find_words=best_price.scan(/[0-9a-zа-я]{5,66}/i)
best_price=best_price.match(/Завтра\s*плюс\s*.{6}/)
puts(" \b #{best_price} \b \b \b \b ")
find_words.each do |e|
    ##
    if x == 1
        @x2 = e + ' ' + @x2.to_s
    end

    if e == 'Завтра'
        x=1
    end

end

##Завтра     плюс
## best_price=best_price.text



