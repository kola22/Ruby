#!/bin/env ruby
# encoding: utf-8

require 'selenium-webdriver'
require 'nokogiri'
require 'open-uri'

printing_page = Nokogiri::HTML(open("http://kovalut.ru/index.php?kod=6121"))
best_price = printing_page.css('.wi')[0] # This is a overly simple finder. Nokogiri can do xpath searches too.
best_price=best_price.text
arrCURS = best_price.scan(/(\d{1,4}.\d{1,4})/)
puts arrCURS[0]
arrNAME = ['Покупка доллара:','Продажа доллара:','Покупка евро:','Продажа евро:']
x=0
arrCURS.each do |e|
    puts("\n #{arrNAME[x]} #{e} \n")
    x=x+1
end

