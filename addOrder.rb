#!/bin/env ruby
# encoding: utf-8

#Добавление профиля
require '/opt/projects/autotest/Ruby/musthave'

def startTest_addOrder
    #   require '/opt/projects/autotest/Ruby/musthave'
    puts "#{@conslgreen}Начинаем АВТОТЕСТ -- добавление заказа#{@conslwhite}"


    @x=0
    loop do
        choiceBrws 1


        @x=@x+1
        authPUservice 'piletskiy', 'nodakola22', 'piletskiy.abcp.ru', 1

        pnum = "OC90"
        pbrand = "Knecht"

        @driver.find_element(:link_text, "Клиенты").click
        @driver.find_element(:name, "filterCustomersBySearchString").send_keys "xxxx"
        @driver.find_element(:xpath, "//input[@value='Найти']").click
        asleep 2.8

        @driver.get @driver.find_element(:xpath, "//img[@alt='Вход']/parent::a").attribute("href")


        @driver.find_element(:link_text, "Корзина").click

        isElementPresent?(:xpath, "//img[@title='Удалить позицию из корзины']", "clickAlert")

        @driver.find_element(:id, "pcode").send_keys "#{pnum}"
        @driver.find_element(:id, "pcode").submit
        asleep 5
        # @driver.find_element(:xpath,"//div[@class='buyButton']").click
        isElementPresent?(:xpath, "//a[contains(text(),'#{pbrand}')]/parent::*/following-sibling::*/*[contains(text(),'Цены и аналоги')]")
        @driver.find_element(:xpath, "//div[@class='buyButton']/button").click

        findTextInPage ["Товар добавлен в корзину"]
        asleep 5
        @driver.find_element(:link_text, "Корзина").click
     ##   @driver.find_element(:xpath, "//img[@title='Удалить позицию из корзины']").click
      ##  @driver.switch_to.alert.accept
        isElementPresent?(:xpath, "//img[@title='Удалить позицию из корзины']", "clickAlert")

        @driver.find_element(:id, "pcode").clear
        @driver.find_element(:id, "pcode").send_keys "#{pnum}"
        @driver.find_element(:id, "pcode").submit
        asleep 2
        isElementPresent?(:xpath, "//a[contains(text(),'#{pbrand}')]/parent::*/following-sibling::*/*[contains(text(),'Цены и аналоги')]")
        @driver.find_element(:xpath, "//div[@class='buyButton']/button").click
        findTextInPage ["Товар добавлен в корзину"]

        @driver.find_element(:link_text, "Корзина").click

        codePart =@driver.find_element(:class, "brandNumberText").text
        descPart =@driver.find_element(:xpath, "//*[@class='brandNumberText']/parent::*/parent::*/following-sibling::td[1]").text
        delTimePatr = @driver.find_element(:xpath, "//*[@class='brandNumberText']/parent::*/parent::*/following-sibling::td[2]").text
        pricePatr = @driver.find_element(:xpath, "//*[@class='brandNumberText']/parent::*/parent::*/following-sibling::td[5]").text

        arrPartOrderinfo = [codePart, descPart, delTimePatr, pricePatr]

        @driver.find_element(:name, "order_go").click
        @driver.find_element(:class, "orderGo").click
        numOrder =(@driver.find_element(:xpath, "//table[@class='echo_message']").text).match(/([0-9]{1,})/)

        @driver.get @hrefPU
        @driver.find_element(:link_text, "Заказы").click
        @driver.find_element(:link_text, numOrder[0]).click
        findTextInPage arrPartOrderinfo, 0
        sleep 3
        @driver.quit
        break if @x==2
    end
    puts "#{@conslgreen}Тест по добавлению ЗАКАЗА успешно пройден#{@conslwhite}"
end

def startTestaddOrderFrtoGk nameFra, pnum, pbrand, autharr

    #   require '/opt/projects/autotest/Ruby/musthave'
    puts "#{@conslgreen}Начинаем АВТОТЕСТ -- добавление заказа на сайте Франчайзи и отправка в ГК#{@conslwhite}"
    @out_file.puts("\n Отчет прохождения теста по добавлению заказа на сайте Франчайзи и отправке в ГК")
    allstep = 14
    step=0
    @x=1

    begin
        choiceBrws 1
        authPUservice autharr[0], autharr[1], autharr[2], 1
        ### authPUservice 'piletskiy', 'nodakola22', 'piletskiy.abcp.ru', 1

        @driver.find_element(:link_text, "Клиенты").click
        @driver.find_element(:link_text, "Франчайзи").click
        puts nameFra
        hrefPUfranch =@driver.find_element(:xpath, "//*[contains(text(),'#{nameFra}')]/following-sibling::*/*/*[@title='Выполнить вход в панель управления: ']/parent::a").attribute("href")
        puts nameFra
        @driver.get hrefPUfranch
        @out_file.puts("Шаг #{step+=1} из #{allstep} Переходим в ПУ франча")
        @driver.find_element(:link_text, "Клиенты").click
        @driver.find_element(:link_text, "Добавить клиента").click
        clientName = randomTxt(5)
        @driver.find_element(:id, "newCustomerName").send_keys "#{clientName}"
        @driver.find_element(:id, "newCustomerEmail").send_keys "#{clientName}@nodatest.ru"

        @driver.find_element(:xpath, "//span[contains(text(),'Создать')]").click
        isElementPresent?(:xpath, "//span[contains(text(),'Создать')]")
        @out_file.puts("Шаг #{step+=1} из #{allstep} Создаем нового клиента")
        @driver.get @driver.find_element(:link_text, "Вход на сайт от имени клиента: \"#{clientName}\"").attribute("href")
        asleep 3
        @out_file.puts("Шаг #{step+=1} из #{allstep} Входим новым клиентом на сайт")
        @driver.find_element(:link_text, "Корзина").click
        asleep 2
        isElementPresent?(:xpath, "//img[@title='Удалить позицию из корзины']", "clickAlert")

        @driver.find_element(:id, "pcode").send_keys "#{pnum}"
        @driver.find_element(:id, "pcode").submit
        asleep 2
        isElementPresent?(:xpath, "//a[contains(text(),'#{pbrand}')]/parent::*/following-sibling::*/*[contains(text(),'Цены и аналоги')]")
        @driver.find_element(:xpath, "//div[@class='buyButton']/button").click
        findTextInPage ["Товар добавлен в корзину"]
        @out_file.puts("Шаг #{step+=1} из #{allstep} Добавляем товар в корзину")

        asleep 2
        @driver.find_element(:link_text, "Корзина").click
        isElementPresent?(:xpath, "//img[@title='Удалить позицию из корзины']", "clickAlert")
        @out_file.puts("Шаг #{step+=1} из #{allstep} Удаляем товар из корзины")
        ##@driver.find_element(:xpath, "//img[@title='Удалить позицию из корзины']").click
        ##@driver.switch_to.alert.accept

        @driver.find_element(:id, "pcode").clear
        @driver.find_element(:id, "pcode").send_keys "#{pnum}"
        @driver.find_element(:id, "pcode").submit
        asleep 7
        isElementPresent?(:xpath, "//a[contains(text(),'#{pbrand}')]/parent::*/following-sibling::*/*[contains(text(),'Цены и аналоги')]")
        @driver.find_element(:xpath, "//div[@class='buyButton']/button").click
        findTextInPage ["Товар добавлен в корзину"]
        @out_file.puts("Шаг #{step+=1} из #{allstep} Опять добавляем")
        @driver.find_element(:link_text, "Корзина").click

        codePart =@driver.find_element(:class, "brandNumberText").text
        descPart =@driver.find_element(:xpath, "//*[@class='brandNumberText']/parent::*/parent::*/following-sibling::td[1]").text
        delTimePatr = @driver.find_element(:xpath, "//*[@class='brandNumberText']/parent::*/parent::*/following-sibling::td[2]").text
        pricePatr = @driver.find_element(:xpath, "//*[@class='brandNumberText']/parent::*/parent::*/following-sibling::td[5]").text
        comment = randomTxt (10)
        @driver.find_element(:xpath, "//*[@class='brandNumberText']/parent::*/parent::*/following-sibling::td[7]/input").send_keys comment

        arrPartOrderinfo = [codePart, descPart, delTimePatr, pricePatr]


        @driver.find_element(:name, "order_go").click
        @driver.find_element(:class, "orderGo").click
        numOrder =(@driver.find_element(:xpath, "//table[@class='echo_message']").text).match(/([0-9]{1,})/)
        @out_file.puts("Шаг #{step+=1} из #{allstep} Успешно оформляем заказ. Запоминаем его номер и данные о позиции")

        @driver.get hrefPUfranch
        @driver.find_element(:link_text, "Заказы").click
        @driver.find_element(:link_text, numOrder[0]).click
        @out_file.puts("Шаг #{step+=1} из #{allstep} Переходим в наш заказ")
        findTextInPage arrPartOrderinfo, 0
        @out_file.puts("Шаг #{step+=1} из #{allstep} Проверяем данные в заказе")

        @driver.find_element(:xpath, "//input[@class='placeOrder']").click

        @driver.find_element(:xpath, "//input[@value='Отправить заказ поставщику']").click
        asleep 3
        @driver.find_element(:xpath, "//span[contains(text(),'Отправить')]").click
        @out_file.puts("Шаг #{step+=1} из #{allstep} Отправляем заказ поставщику")
        asleep 3
        findTextInPage ["Получен"], 0


        @driver.get @hrefPU
        @out_file.puts("Шаг #{step+=1} из #{allstep} Переходим в ПУ ГК")
        @driver.find_element(:link_text, 'Заказы').click
        @driver.find_element(:link_text, 'Поиск в заказах').click
        @driver.find_element(:name, 'searchcode').send_keys ("#{pnum}")
        @driver.find_element(:name, 'filterDateRange').click
        asleep
        @driver.find_element(:xpath, "//a[contains(text(),'Сегодня')]").click
        asleep
        @out_file.puts("Шаг #{step+=1} из #{allstep} Выставляем фильтр по поиску заказов на ГК. Дата -- Сегодня, Код детали -- #{pnum}")

        @driver.find_element(:xpath, "//input[@value='Найти']").click
        @driver.get @driver.find_element(:xpath, "//*[contains(text(),'#{comment}')]/preceding-sibling::td[19]/a").attribute("href")
        @out_file.puts("Шаг #{step+=1} из #{allstep} Переходим в найденный заказ")
        findTextInPage ["Получен", "Статус"], 0
        @out_file.puts("Шаг #{step+=1} из #{allstep} Проверяем некоторые данные из заказа")
        puts "#{@conslgreen}Тест по добавлению перезаказа успешно пройден#{@conslwhite}"
        @driver.quit
    rescue
        a = Time.now.hour.to_s + ':' + Time.now.min.to_s + '_'+Time.now.day.to_s + '_' + Time.now.strftime("%B").to_s
        @driver.save_screenshot("screen/#{a}_ошибка_в_добавлении_заказа на ГК через франча.png")
        puts "#{@conslred}Тест по добавлению заказа на сайте Франчайзи и отправке в ГК не пройден, всё плохо #{@conslwhite}"
        @out_file.puts('ERR: тест прерван')
    end

end



