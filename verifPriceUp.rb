#!/bin/env ruby
# encoding: utf-8

#Добавление профиля
require '/opt/projects/autotest/Ruby/musthave'

def verifPriceUp autharr,nameFra=false
    ## для этого автотеста необходимо наличие хоть какого-то товара в результатах поиска, именно поэтому мы будем распологать его после добавления прайсов в тестовом наборе
    puts "#{@conslgreen}Начинаем АВТОТЕСТ -- проверка наценок в профиле клиента#{@conslwhite}"
    @out_file.puts("\n Отчет прохождения теста по проверке наценок в профиле клиента")
    step = 0
    allstep = 11
    pnum = 'OC90'
    begin

        choiceBrws 1
        authPUservice autharr[0], autharr[1], autharr[2], 1

    @out_file.puts("Шаг #{step+=1} из #{allstep} Выставляем отображение цены закупки для менеджеров")
        checkedPriceIn 'priceBuyEnable'
        checkedPriceIn 'distributorEnable'

    if nameFra
        @driver.find_element(:link_text, 'Клиенты').click
        @driver.find_element(:link_text, 'Франчайзи').click
        hrefPUfranch =@driver.find_element(:xpath, "//*[contains(text(),'#{nameFra}')]/following-sibling::*/*/*[@title='Выполнить вход в панель управления: ']/parent::a").attribute("href")
        @driver.get hrefPUfranch
    end

    @out_file.puts("Шаг #{step+=1} из #{allstep} Получаем сслыку для входа на сайт менеджером (администратором)")
        @driver.find_element(:link_text,'Персонал').click
        hrefSiteAdmin = @driver.find_element(:xpath, "//*[contains(text(),'admin')]/following-sibling::td[12]/a").attribute("href")
        puts hrefSiteAdmin
=begin
    @out_file.puts("Шаг #{step+=1} из #{allstep} Создаем нового клиента. Получаем ссылку для входа на сайт. Новый клиент должен создавать по дефолту без профиля")
        @driver.find_element(:link_text, "Клиенты").click
        @driver.find_element(:link_text, "Добавить клиента").click
        clientName = randomTxt(15)
        @driver.find_element(:id, "newCustomerName").send_keys "#{clientName}"
        @driver.find_element(:id, "newCustomerEmail").send_keys "#{clientName}nodatest@nodasoft.com"
        @driver.find_element(:xpath, "//span[contains(text(),'Создать')]").click
        isElementPresent?(:xpath, "//span[contains(text(),'Создать')]")
        hrefSiteClient = @driver.find_element(:link_text, "Вход на сайт от имени клиента: \"#{clientName}\"").attribute("href")
=end
        hrefSiteClient = 'http://piletskiy.abcp.ru/?tlogin=NzCiVXnofVwJMAMnodatest@nodasoft.com&authCode=0fe910fe41bd4386e9d0d89b77fce6e7'

    @out_file.puts("Шаг #{step+=1} из #{allstep} Переходим на сайт менеджером, ищем деталь #{pnum} и получаем её закупочную цену,бренд и постащика")
        @driver.get hrefSiteAdmin
        @driver.find_element(:id, "pcode").send_keys "#{pnum}"
        @driver.find_element(:id, "pcode").submit
        isElementPresent?(:xpath, "//*[contains(text(),'Цены и аналоги')]")
        brand = @driver.find_element(:class,'brandInfoLink').text
        priceIn = @driver.find_element(:class,'resultPurchasesPrice').text ## тут мы получаем запись вида : 33,00 руб , надо бы перевести
        priceInFloat = priceIn.match(/(\d*,\d{2})/).to_s.sub!(',','.').to_f.round(2)
        description = @driver.find_element(:class,'resultDescription  ').text
        dist = @driver.find_element(:class,'resultSupplier  ').text
        puts dist,priceInFloat,brand,description

    @out_file.puts("Шаг #{step+=1} из #{allstep} Переходим на сайт клиентом и видим цену продажи детали OC90 равную закупке, так как не выставлен профиль")
        @driver.get hrefSiteClient
        asleep
        @driver.find_element(:id, "pcode").send_keys "#{pnum}"
        @driver.find_element(:id, "pcode").submit
        isElementPresent?(:xpath, "//*[contains(text(),'Цены и аналоги')]")
        temp = @driver.find_element(:xpath,"//*[@class='resultDescription  '][contains(text(),'#{description}')]/following-sibling::*[@class='resultPrice ']").text
        puts temp
        temp = temp.match(/(\d*,\d{2})/).to_s.sub!(',','.').to_f.round(2)
        puts temp
        if temp == priceInFloat
            puts 'Проверка пройдена. Цена у клиента без наценки равна цене закупки'
        else
            puts 'ERR: цена у клиента без наценки не совпадает с ценой закупки!'
        end

        gets


    @out_file.puts("Шаг #{step+=1} из #{allstep} В ПУ создаем профиль без наценки, устанавливаем клиенту")

    @out_file.puts("Шаг #{step+=1} из #{allstep} На сайте цена не поменялась")

    @out_file.puts("Шаг #{step+=1} из #{allstep} Меняем для профиля наценку , ставим 100")

    @out_file.puts("Шаг #{step+=1} из #{allstep} На сайте цена выросла в два раза")

    @out_file.puts("Шаг #{step+=1} из #{allstep} Меняем для профиля наценку, ставим -100")

    @out_file.puts("Шаг #{step+=1} из #{allstep} На сайте цена снизилась в два раза")

    @out_file.puts("Шаг #{step+=1} из #{allstep} Устанавливаем наценку на поставщика в профиле 77,7%")

    @out_file.puts("Шаг #{step+=1} из #{allstep} На сайте цена выросла на 77,7% от закупки")

        @out_file.puts("Шаг #{step+=1} из #{allstep} Устанавливаем наценку на бренд в профиле -22%")

        @out_file.puts("Шаг #{step+=1} из #{allstep} На сайте цена уменьшилась на 22 процента от закупочной")


 ##   rescue
        @err+=1
        puts "#{@conslred}ERR: Тест не пройден, всё плохо #{@conslwhite}"
        @out_file.puts('ERR: Тест прерван')
    end
    @driver.quit

end









