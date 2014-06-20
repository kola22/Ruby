#!/bin/env ruby
# encoding: utf-8

noRun = 0

require 'selenium-webdriver'
require '/opt/projects/autotest/Ruby/musthave'
require '/opt/projects/autotest/Ruby/addOrder'
require '/opt/projects/autotest/Ruby/addFranchToPiletskiy'
require '/opt/projects/autotest/Ruby/Addprofile'
require '/opt/projects/autotest/Ruby/addPriceToDistr'
require '/opt/projects/autotest/Ruby/forMcOtzivi'
require '/opt/projects/autotest/Ruby/forMcOtziviShop'

while Time.now.year < 2015
    a = Time.now.hour.to_s + ':' + Time.now.min.to_s + '_'+Time.now.day.to_s + '_' + Time.now.strftime("%B").to_s

    @namefile = "out_#{a}.txt"
    @out_file = File.new(@namefile, 'w')
    @out_file.puts("Отчет прохождения теста\n ")
    @out_file.puts("Время запуска теста: #{Time.now}\n ")

    begin

        a = Time.now
        autArr = ['piletskiy', 'nodakola22', 'piletskiy.abcp.ru']
        autArr4mc = ['piletskiy', 'nodakola22', '4mycar.ru']
        addPriceToDistr autArr
        forMcOtzivi autArr4mc
        startTestaddFranch autArr
        forMcOtziviShop autArr4mc

        choiceBrws
        authPUservice autArr[0], autArr[1], autArr[2], 1
        @driver.find_element(:link_text, 'Поставщики').click
        while isElementPresentlite(:xpath, "//*[contains(text(),'Идёт обновление прайс-листа...')]")
            @driver.find_element(:link_text, 'Поставщики').click
            asleep 10, 'Ещё не загрузился файл'
        end
        @driver.quit

        startTest_addprofile
        startTest_addprofile_toFranch 'piletskiy.abcp.ru', @nameCity


        startTest_addOrder
        startTestaddOrderFrtoGk @nameCity, 'OC90', 'Knecht', autArr

        sum = ((Time.now - a)/60).round 2
        puts "#{@conslgreen}Все тесты успешно пройдены#{@conslwhite},время прохождения: #{sum} минут"
        @out_file.puts("Все тесты успешно пройдены,время прохождения: #{sum} минут")
    rescue
        @out_file.puts("\n \n  Весь тестовый набор не пройдён\n ")
        puts 'Весь набор не пройдён'
        noRun+=1
    end
    temp = 'Тестовый набор не прошел: ' + noRun.to_s + 'раз'
    @out_file.puts("#{temp}\n ")
    @out_file.puts("Время окончания теста: #{Time.now}\n ")
    @out_file.close

    addReportToPage
    asleep 3600*6
end