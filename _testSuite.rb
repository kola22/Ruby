#!/bin/env ruby
# encoding: utf-8
#--
## цели на добавления тестов:
## может загрузка моих_каталогов и проверка на отображение? --- вообще функционал древний.кривой.и не нужный, поэтому наверно нет...
## DONE:                      1 недавно была задача по приоритетам на текстовых сообщениях ГК и франча
## 3 ТЕК док всё же надо как-то проверять , а зачем аа ?
## 4 может быть винкью . наверно попозже
## 5 недавняя задача, проверка письма о ошибке генерации прайса 4мс
## 6 ВИН-запросы. Обычные. С сайта.
## DONE: парсер нокогири : курсы валют (done), актуальную погоду (done), срочно с Авито-Таганрог :p,
## DONE: ценообразование.
## 2 задача у команды САши на тестирование онлайн поставщиков // наверно там всё таки нечего делать автотестам

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
require '/opt/projects/autotest/Ruby/verifPriceUp'
require '/opt/projects/autotest/Ruby/findErrAnnScreeShot'

if ARGV[0] == '.lan'
@lan=ARGV[0]
end

def timeNow
    aa=Time.now.hour.to_s + ':' + Time.now.min.to_s + '_'+Time.now.day.to_s + '_' + Time.now.strftime("%B").to_s
    return aa
end
@needrun = ARGV[0]
while Time.now.year < 2018
    a = timeNow
    ##a = Time.now.hour.to_s + ':' + Time.now.min.to_s + '_'+Time.now.day.to_s + '_' + Time.now.strftime("%B").to_s
    @err = 0
    @namefile = "out_#{a}.txt"
    @out_file = File.new(@namefile, 'w')
    parserCurrency
    parserPogodaTGKMSK
    ##@out_file.puts("Отчет прохождения теста\n ")
    @out_file.puts("Время запуска теста: #{Time.now}\n ")

    begin
            a = Time.now
            autArrSpecial = ['piletskiy', 'nodakola22', 'parts.portalavto.com']
            autArrSpecial2 = ['piletskiy', 'nodakola22', 'bilstein.ru']
            autArr = ['piletskiy', 'nodakola22', 'piletskiy.abcp.ru']
            autArr4mc = ['piletskiy', 'nodakola22', '4mycar.ru']
            autArrAutotest = ['piletskiy', 'nodakola22', 'autotestvirtual']
            autArrSpecial_2 = ['piletskiy', 'nodakola22', 'chida.ru']

           # addPriceToDistr autArr,'priceautotes.xls',@nameCity
           # waitUntilLoadPrice autArr,@nameCity,@nameDistr
           # addPriceToDistr autArr,'priceautotes.xls'
           # waitUntilLoadPrice autArr,false,@nameDistr
           # verifPriceUp autArr,false,'OC90'



            ## <костыль> для проверочных запусков в виртуальной машине, хотел конечно задавть имя функции в передаваемый параметр, да вот только не знаю как это реализовать
            if @needrun == 'addPriceToDistr'
                addPriceToDistr autArr,'русский.xls'
            elsif @needrun == 'startTestaddFranch'
                startTestaddFranch autArr
            elsif @needrun == 'forMcOtzivi'
                forMcOtzivi autArr4mc
            elsif @needrun == 'startTest_addOrder'
                startTest_addOrder autArr
            elsif @needrun == 'startTest_addprofile'
                startTest_addprofile autArr
            elsif @needrun == 'verifPriceUp'
                verifPriceUp autArr,false,'OC90'
            elsif @needrun == 'localText'
                localText autArrAutotest,'Гуково'
            elsif @needrun == 'findErrAnnScreeShot'
               while Time.now.year < 2018

                    timeNow
                    findErrAnnScreeShot autArrSpecial
                    timeNow
                    findErrAnnScreeShot autArrSpecial2
                end

            elsif @needrun == 'findErrAnnScreeShotChida'
                while Time.now.year < 2018
                    puts timeNow
                    findErrAnnScreeShotChida autArrSpecial_2
                    asleep 300
                end
            end
            ## </костыль>

            addPriceToDistr autArr,'русский.xls'
            addPriceToDistr autArr,'priceautotes.xls'
            startTestaddFranch autArr

            if @lan !='.lan'
                forMcOtziviShop autArr4mc                       ## нельзя локально проверить, из-за перенаправлений на 4мс из аккаунтс
               # forMcOtzivi autArr4mc                           ## нельзя локально проверить, из-за перенаправлений на 4мс из аккаунтс
                startTest_addprofile autArr                     ## нельзя локально проверить, из-за ошибки при посылке аякс запроса
                startTest_addprofile_toFranch autArr, @nameCity ## нельзя локально проверить, из-за ошибки при посылке аякс запроса
            end

            localText autArrAutotest,'Гуково'
        waitUntilLoadPrice autArr,false,@nameDistr
            # # if rand(0..2) == 1
            verifPriceUp autArr,false,'OC90'
            # # end
            @nameDistr = []
            startTestaddOrderFrtoGk @nameCity, 'OC90', 'Knecht', autArr
            addPriceToDistr autArr,'русский.xls',@nameCity
            addPriceToDistr autArr,'priceautotes.xls',@nameCity
            startTest_addOrder autArr
        waitUntilLoadPrice autArr,@nameCity,@nameDistr

            if rand(0..2) == 1
            verifPriceUp autArr,@nameCity,'OC90'
            end
            sum = ((Time.now - a)/60).round 2
        ## тут должен быть delResellerFra autArr, @nameCity
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
    @out_file.puts("\n Время окончания теста: #{Time.now}\n ")
    @out_file.close
    addReportToPage
    asleep 3600*2
end