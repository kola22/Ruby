#!/bin/env ruby
# encoding: utf-8

#--
## цели на добавления тестов:
## DONE:                      1 недавно была задача по приоритетам на текстовых сообщениях ГК и франча
## 2 задача у команды САши на тестирование онлайн поставщиков
## 3 ТЕК док всё же надо как-то проверять , а зачем аа ?
## 4 может быть винкью . наверно попозже
## 5 недавняя задача, проверка письма о ошибке генерации прайса 4мс

noRun = 0
@nameDistr = []
require 'selenium-webdriver'
require '/opt/projects/autotest/Ruby/musthave'
require '/opt/projects/autotest/Ruby/addOrder'
require '/opt/projects/autotest/Ruby/addFranchToPiletskiy'
require '/opt/projects/autotest/Ruby/Addprofile'
require '/opt/projects/autotest/Ruby/addPriceToDistr'
require '/opt/projects/autotest/Ruby/forMcOtzivi'
require '/opt/projects/autotest/Ruby/forMcOtziviShop'
require '/opt/projects/autotest/Ruby/localText'

while Time.now.year < 2018
    a = Time.now.hour.to_s + ':' + Time.now.min.to_s + '_'+Time.now.day.to_s + '_' + Time.now.strftime("%B").to_s
    @err = 0
    @namefile = "out_#{a}.txt"
    @out_file = File.new(@namefile, 'w')
    ##@out_file.puts("Отчет прохождения теста\n ")
    @out_file.puts("Время запуска теста: #{Time.now}\n ")
    begin
        ###
        a = Time.now
        autArr = ['piletskiy', 'nodakola22', 'piletskiy.abcp.ru']
        autArr4mc = ['piletskiy', 'nodakola22', '4mycar.ru']
        autArrAutotest = ['piletskiy', 'nodakola22', 'autotestvirtual']


        forMcOtziviShop autArr4mc
        forMcOtzivi autArr4mc
        addPriceToDistr autArr,'русский.xls'
        addPriceToDistr autArr,'priceautotes.xls'
        localText autArrAutotest,'Гуково'

        startTestaddFranch autArr
        startTest_addprofile autArr
        startTest_addprofile_toFranch autArr, @nameCity
        waitUntilLoadPrice autArr,false,@nameDistr
        @nameDistr = []
        startTestaddOrderFrtoGk @nameCity, 'OC90', 'Knecht', autArr
        addPriceToDistr autArr,'русский.xls',@nameCity
        addPriceToDistr autArr,'priceautotes.xls',@nameCity
        startTest_addOrder
        waitUntilLoadPrice autArr,@nameCity,@nameDistr

        sum = ((Time.now - a)/60).round 2
  ##      puts "#{@conslgreen}Все тесты успешно пройдены#{@conslwhite},время прохождения: #{sum} минут"
    rescue
        errrun = true
        @out_file.puts("\n \n  Весь тестовый набор не пройдён\n ")
        puts "#{@conslred}Весь набор не пройдён#{@conslwhite}"
        noRun+=1
        temp = 'Тестовый набор не прошел: ' + noRun.to_s + 'раз'
        @out_file.puts("#{temp}\n ")
    end
    if errrun
        else
            @out_file.puts("Время прохождения: #{sum} минут")
            @out_file.puts("Не прошло тестов: #{@err}")
    end

    @out_file.puts("Время окончания теста: #{Time.now}\n ")
    @out_file.close
    addReportToPage
    asleep 3600*2
end