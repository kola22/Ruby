#!/bin/env ruby
# encoding: utf-8

#Добавление франча
require '/opt/projects/autotest/Ruby/musthave'


def findErrAnnScreeShot autharr
    a = Time.now.hour.to_s + ':' + Time.now.min.to_s + '_'+Time.now.day.to_s + '_' + Time.now.strftime("%B").to_s
    begin
    choiceBrws 1
    authPUservice autharr[0], autharr[1], autharr[2],333
    $driver.find_element(:link_text, 'Клиенты').click
    $driver.find_element(:link_text, 'Отчеты').click
    $driver.find_element(:link_text, 'Заказы').click
    $driver.find_element(:link_text, 'Главная').click
    $driver.get "http://#{autharr[2]}"
    $driver.find_element(:id, "pcode").send_keys "OC90"
    $driver.find_element(:id, "pcode").submit
    rescue
    puts 'сайт лег!'
    $driver.save_screenshot("screen/#{a}.png")
    end
    $driver.quit
end