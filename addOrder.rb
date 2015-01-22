#!/bin/env ruby
# encoding: utf-8

#Добавление профиля
require '/opt/projects/autotest/Ruby/musthave'

def startTest_addOrder autharr
    #   require '/opt/projects/autotest/Ruby/musthave'
    puts "#{$conslgreen}Начинаем АВТОТЕСТ -- добавление заказа#{$conslwhite}"
    $out_file.puts("\n Отчет прохождения теста по добавлению заказа")
    step = 0
    allstep = 11

    begin
        choiceBrws 1
        authPUservice autharr[0], autharr[1], autharr[2], 1

        pnum = "OC90"
        pbrand = "Knecht"

        $driver.find_element(:link_text, "Клиенты").click
        $driver.find_element(:name, "filterCustomersBySearchString").send_keys "xxxx"

        $driver.find_element(:xpath, "//input[@value='Найти']").click
        asleep 2.8

        $driver.get $driver.find_element(:xpath, "//img[@alt='Вход']/parent::a").attribute("href")
        $out_file.puts("Шаг #{step+=1} из #{allstep} Ищем клиента хххх и входим им на сайт")

        $driver.find_element(:link_text, "Корзина").click

        isElementPresent?(:xpath, "//img[@title='Удалить позицию из корзины']", "clickAlert")
        $out_file.puts("Шаг #{step+=1} из #{allstep} Удаляем из корзины всё позиции, если они там есть")
        $driver.find_element(:id, "pcode").send_keys "#{pnum}"
        $driver.find_element(:id, "pcode").submit
        $out_file.puts("Шаг #{step+=1} из #{allstep} Выполняем поиск детали по коду #{pnum}")
        asleep
        # $driver.find_element(:xpath,"//div[@class='buyButton']").click
        isElementPresent?(:xpath, "//a[contains(text(),'#{pbrand}')]/parent::*/following-sibling::*/*[contains(text(),'Цены и аналоги')]")
        $driver.find_element(:xpath, "//div[@class='buyButton']/button").click
        $out_file.puts("Шаг #{step+=1} из #{allstep} Покупаем первую позицию в поиске")
        findTextInPage ["Товар добавлен в корзину"],0
        asleep
        $driver.find_element(:link_text, "Корзина").click
        isElementPresent?(:xpath, "//img[@title='Удалить позицию из корзины']", "clickAlert")
        $out_file.puts("Шаг #{step+=1} из #{allstep} Удаляем добавленную позицию из корзины")
        $driver.find_element(:id, "pcode").clear
        $driver.find_element(:id, "pcode").send_keys "#{pnum}"
        $driver.find_element(:id, "pcode").submit
        $out_file.puts("Шаг #{step+=1} из #{allstep} Ещё раз ищем")
        asleep
        isElementPresent?(:xpath, "//a[contains(text(),'#{pbrand}')]/parent::*/following-sibling::*/*[contains(text(),'Цены и аналоги')]")
        $driver.find_element(:xpath, "//div[@class='buyButton']/button").click
        $out_file.puts("Шаг #{step+=1} из #{allstep} И ещё раз покупаем")
        findTextInPage ["Товар добавлен в корзину"],0
        $driver.find_element(:link_text, "Корзина").click
        codePart =$driver.find_element(:class, "brandNumberText").text
        descPart =$driver.find_element(:xpath, "//*[@class='brandNumberText']/parent::*/parent::*/following-sibling::td[1]").text
        delTimePatr = $driver.find_element(:xpath, "//*[@class='brandNumberText']/parent::*/parent::*/following-sibling::td[2]").text
        pricePatr = $driver.find_element(:xpath, "//*[@class='brandNumberText']/parent::*/parent::*/following-sibling::td[5]").text
        arrPartOrderinfo = [codePart, descPart, delTimePatr, pricePatr]
        $driver.find_element(:name, "order_go").click
        $driver.find_element(:class, "orderGo").click
        numOrder =$driver.find_element(:xpath, "//div[@class='fr-alert fr-alert-success']/strong").text
        puts numOrder

        ##).match(/([0-9]{1,})/)
        $out_file.puts("Шаг #{step+=1} из #{allstep} Получаем номер заказа. --> #{numOrder}")

        $driver.get @hrefPU
        $driver.find_element(:link_text, "Заказы").click
        $driver.find_element(:link_text, numOrder).click
        $out_file.puts("Шаг #{step+=1} из #{allstep} Переходим в ПУ в заказ")
        findTextInPage arrPartOrderinfo, 0
        $out_file.puts("Шаг #{step+=1} из #{allstep} Проверяем, что данные в ПУ соответствуют данным при заказе с сайта")
        verifSendEmailOrder numOrder
        $out_file.puts("Шаг #{step+=1} из #{allstep} Проверяем отосланные письма о заказе")
        puts "#{$conslgreen}Тест по добавлению ЗАКАЗА успешно пройден#{$conslwhite}"
    rescue
        $err+=1
        a = Time.now.hour.to_s + ':' + Time.now.min.to_s + '_'+Time.now.day.to_s + '_' + Time.now.strftime("%B").to_s
        puts "#{$conslred}Тест по добавлению заказа не пройден, всё плохо #{$conslwhite}"
        $out_file.puts('ERR: тест прерван')
    end
        $driver.quit

end

def startTestaddOrderFrtoGk nameFra, pnum, pbrand, autharr

    puts "#{$conslgreen}Начинаем АВТОТЕСТ -- добавление заказа на сайте Франчайзи и отправка в ГК#{$conslwhite}"
    $out_file.puts("\n Отчет прохождения теста по добавлению заказа на сайте Франчайзи и отправке в ГК")
    allstep = 14
    step=0

    begin
        choiceBrws 1
        authPUservice autharr[0], autharr[1], autharr[2], 1

        $driver.find_element(:link_text, "Клиенты").click
        $driver.find_element(:link_text, "Франчайзи").click
        hrefPUfranch =$driver.find_element(:xpath, "//*[contains(text(),'#{nameFra}')]/following-sibling::*/*/*[@title='Выполнить вход в панель управления: ']/parent::a").attribute("href")
        $driver.get hrefPUfranch
        $out_file.puts("Шаг #{step+=1} из #{allstep} Переходим в ПУ франча")
        $driver.find_element(:link_text, "Клиенты").click
        $driver.find_element(:link_text, "Добавить клиента").click
        clientName = randomTxt(5)
        $driver.find_element(:id, "newCustomerName").send_keys "#{clientName}"
        $driver.find_element(:id, "newCustomerEmail").send_keys "#{clientName}nodatest@nodasoft.com"

        $driver.find_element(:xpath, "//span[contains(text(),'Создать')]").click
        isElementPresent?(:xpath, "//span[contains(text(),'Создать')]")
        $out_file.puts("Шаг #{step+=1} из #{allstep} Создаем нового клиента")
        $driver.get $driver.find_element(:link_text, "Вход на сайт от имени клиента: \"#{clientName}\"").attribute("href")
        asleep
        $out_file.puts("Шаг #{step+=1} из #{allstep} Входим новым клиентом на сайт")
        $driver.find_element(:link_text, "Корзина").click
        asleep 2
        isElementPresent?(:xpath, "//img[@title='Удалить позицию из корзины']", "clickAlert")

        $driver.find_element(:id, "pcode").send_keys "#{pnum}"
        $driver.find_element(:id, "pcode").submit
        asleep 2
        isElementPresent?(:xpath, "//a[contains(text(),'#{pbrand}')]/parent::*/following-sibling::*/*[contains(text(),'Цены и аналоги')]")
        $driver.find_element(:xpath, "//div[@class='buyButton']/button").click
        findTextInPage ["Товар добавлен в корзину"],0


        $out_file.puts("Шаг #{step+=1} из #{allstep} Добавляем товар в корзину")

        asleep
        $driver.find_element(:link_text, "Корзина").click
        isElementPresent?(:xpath, "//img[@title='Удалить позицию из корзины']", "clickAlert")
        $out_file.puts("Шаг #{step+=1} из #{allstep} Удаляем товар из корзины")
        ## шаг 5
        ##$driver.find_element(:xpath, "//img[@title='Удалить позицию из корзины']").click
        ##$driver.switch_to.alert.accept

        $driver.find_element(:id, "pcode").clear
        $driver.find_element(:id, "pcode").send_keys "#{pnum}"
        $driver.find_element(:id, "pcode").submit
        asleep 7
        isElementPresent?(:xpath, "//a[contains(text(),'#{pbrand}')]/parent::*/following-sibling::*/*[contains(text(),'Цены и аналоги')]")
        $driver.find_element(:xpath, "//div[@class='buyButton']/button").click
        findTextInPage ["Товар добавлен в корзину"],0
        $out_file.puts("Шаг #{step+=1} из #{allstep} Опять добавляем")
        $driver.find_element(:link_text, "Корзина").click

        codePart =$driver.find_element(:class, "brandNumberText").text
        descPart =$driver.find_element(:xpath, "//*[@class='brandNumberText']/parent::*/parent::*/following-sibling::td[1]").text
        delTimePatr = $driver.find_element(:xpath, "//*[@class='brandNumberText']/parent::*/parent::*/following-sibling::td[2]").text
        pricePatr = $driver.find_element(:xpath, "//*[@class='brandNumberText']/parent::*/parent::*/following-sibling::td[5]").text
        comment = randomTxt (10)
        $driver.find_element(:xpath, "//*[@class='brandNumberText']/parent::*/parent::*/following-sibling::td[7]/input").send_keys comment

        arrPartOrderinfo = [codePart, descPart, delTimePatr, pricePatr]

        $driver.find_element(:name, "order_go").click
        $driver.find_element(:class, "orderGo").click
        numOrder =$driver.find_element(:xpath, "//div[@class='fr-alert fr-alert-success']/strong").text ##).match(/([0-9]{1,})/)
        $out_file.puts("Шаг #{step+=1} из #{allstep} Успешно оформляем заказ. Запоминаем его номер и данные о позиции")




        $driver.get hrefPUfranch
        $driver.find_element(:link_text, "Заказы").click
        $driver.find_element(:link_text, numOrder).click
        $out_file.puts("Шаг #{step+=1} из #{allstep} Переходим в наш заказ")
        findTextInPage arrPartOrderinfo, 0
        $out_file.puts("Шаг #{step+=1} из #{allstep} Проверяем данные в заказе")

        $driver.find_element(:xpath, "//input[@class='placeOrder']").click

        $driver.find_element(:xpath, "//input[@value='Отправить заказ поставщику']").click
        asleep
        $driver.find_element(:xpath, "//span[contains(text(),'Отправить')]").click
        $out_file.puts("Шаг #{step+=1} из #{allstep} Отправляем заказ поставщику")
        asleep
        findTextInPage ["Получен"], 0
        $driver.find_element(:xpath, "//span[contains(text(),'Закрыть')]").click
        textStatusGk = $driver.find_element(:xpath,"//*[contains(text(),'#{comment}')]/preceding-sibling::td[1]").text
        textStatusGk = textStatusGk.match(/([0-9]{1,})/)

        verifSendEmailOrder numOrder


        $driver.get @hrefPU
        $out_file.puts("Шаг #{step+=1} из #{allstep} Переходим в ПУ ГК")
        $driver.find_element(:link_text, 'Заказы').click
        $driver.find_element(:link_text, 'Все заказы').click
        ##$driver.find_element(:name, 'searchcode').send_keys ("#{pnum}")
        ##$driver.find_element(:name, 'filterDateRange').click
        ##asleep
        ##$driver.find_element(:xpath, "//a[contains(text(),'Сегодня')]").click
        ##asleep
        textStatusGk = textStatusGk.to_s
        $driver.find_element(:name,'filter_order').send_keys textStatusGk
        $out_file.puts("Шаг #{step+=1} из #{allstep} Выставляем фильтр по поиску заказов на ГК. Дата -- Сегодня, Код детали -- #{pnum}")

        $driver.find_element(:xpath, "//input[@value='Применить фильтры']").click
        $driver.find_element(:link_text,textStatusGk).click


        ############ не работает теперь коммент
        ##$driver.get $driver.find_element(:xpath, "//*[contains(text(),'#{comment}')]/preceding-sibling::td[19]/a").attribute("href")
        $out_file.puts("Шаг #{step+=1} из #{allstep} Переходим в найденный заказ")
        findTextInPage ["Получен", "Статус"], 0
        $out_file.puts("Шаг #{step+=1} из #{allstep} Проверяем некоторые данные из заказа")


        puts "#{$conslgreen}Тест по добавлению перезаказа успешно пройден#{$conslwhite}"



    rescue
        $err+=1
        a = Time.now.hour.to_s + ':' + Time.now.min.to_s + '_'+Time.now.day.to_s + '_' + Time.now.strftime("%B").to_s
        $driver.save_screenshot("screen/#{a}_ошибка_в_добавлении_заказа на ГК через франча.png")
        puts "#{$conslred}Тест по добавлению заказа на сайте Франчайзи и отправке в ГК не пройден, всё плохо #{$conslwhite}"
        $out_file.puts('ERR: тест прерван')
    end
    $driver.quit
end



