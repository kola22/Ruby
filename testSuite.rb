#!/bin/env ruby
# encoding: utf-8

noRun = 0
@x=1
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

    @err = 0
    @namefile = "out_#{a}.txt"
    @out_file = File.new(@namefile, 'w')
    @out_file.puts("Отчет прохождения теста\n ")
    @out_file.puts("Время запуска теста: #{Time.now}\n ")

    begin
        a = Time.now
        autArr = ['piletskiy', 'nodakola22', 'piletskiy.abcp.ru']
        autArr4mc = ['piletskiy', 'nodakola22', '4mycar.ru']
        startTest_addOrder
        startTestaddFranch autArr
        startTestaddOrderFrtoGk @nameCity, 'OC90', 'Knecht', autArr

        addPriceToDistr autArr,1,@nameCity
        addPriceToDistr autArr
        waitUntilLoadPrice autArr
        forMcOtzivi autArr4mc
        forMcOtziviShop autArr4mc

        startTest_addprofile
        startTest_addprofile_toFranch 'piletskiy.abcp.ru', @nameCity

        startTestaddOrderFrtoGk @nameCity, 'OC90', 'Knecht', autArr
        sum = ((Time.now - a)/60).round 2
  ##      puts "#{@conslgreen}Все тесты успешно пройдены#{@conslwhite},время прохождения: #{sum} минут"
        @out_file.puts("Время прохождения: #{sum} минут")
        @out_file.puts("Не прошло тестов: #{@err}")

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
    asleep 3600*2
end