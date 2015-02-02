#!/bin/env ruby
# encoding: utf-8

#Добавление франча
 require '/opt/projects/autotest/Ruby/musthave'

def startTestaddFranch autharr
    puts "#{@conslgreen}Начинаем АВТОТЕСТ -- добавление франча#{@conslwhite}"
    @out_file.puts("\n Отчет прохождения теста по добавление франча")
    begin
        step = 0
        allstep = 5
        @nameCity = randomTxt(6) + "TestDel" + "_#{Time.now.day}_#{Time.now.month}_#{Time.now.year}"
        choiceBrws 1

        sleep 0.5

        clientName = randomTxt(15)+'testDel'
        authPUservice autharr[0], autharr[1], autharr[2], 1
        # $driver.find_element(:link_text, 'Внешний вид и контент').click
        # $driver.find_element(:link_text, 'Формы').click
        # $driver.find_element(:xpath, "//*[contains(text(),'Форма регистрации розница')]/following-sibling::*/*[@title='Редактировать набор элементов']").click
        #
            $driver.get "http://#{autharr[2]}"
            isElementPresent?(:class,'button-close')
            $driver.find_element(:xpath, "//*[contains(text(),'Регистрация')]").click
            $driver.find_element(:xpath, "//input[@value='Продолжить']").click

        $driver.find_element(:name,'fname').send_keys clientName
        $driver.find_element(:id,'email').send_keys clientName+'nodatest@nodasoft.com'
        password = randomTxt 10
        $driver.find_element(:id,'password').send_keys password
        $driver.find_element(:id,'password_confirm').send_keys password
        $driver.find_element(:id, 'submitRetailButton').click
        ##
=begin
        $driver.find_element(:link_text, 'Клиенты').click
        $driver.find_element(:link_text,'Добавить клиента').click
        $driver.find_element(:id, 'newCustomerName').send_keys "#{clientName}"
        $driver.find_element(:id, 'newCustomerEmail').send_keys "#{clientName}nodatest@nodasoft.com"
        $driver.find_element(:xpath, "//span[contains(text(),'Создать')]").click
=end

        # authPUservice autharr[0], autharr[1], autharr[2], 1
        $driver.get @hrefPU
        $driver.find_element(:link_text, 'Клиенты').click
        $driver.find_element(:link_text, 'Франчайзи').click
        $driver.find_element(:link_text, 'Добавить франчайзи').click
        @out_file.puts("Шаг #{step+=1} из #{allstep} Пытаемся добавить франча")
        $driver.find_element(:name, 'agreeWithCreation').click
        asleep 2
        $driver.find_element(:id, 'clientAliveSearch').send_keys clientName
        asleep 5
        $driver.find_element(:class, 'aliveSearchRow').click
        $driver.find_element(:name, 'email').send_keys("#{@nameCity}nodatest@nodasoft.com")
        $driver.find_element(:name, 'city').send_keys @nameCity
        #$driver.find_element(:class, 'btn').click
        $driver.find_element(:xpath, "//*[@value='Добавить']").click
        findTextInPage ['Добрый день.']
        @out_file.puts("Шаг #{step+=1} из #{allstep} Добавили. Отображается стандартный текст после добавления")
        asleep 30
        $driver.find_element(:link_text, 'Франчайзи').click
    ##    puts "Франчайзи с таким городом добавлен :: #{@nameCity}"

        # hrefPUfra=@wait.until {$driver.find_element(:xpath, "//table[@id='tsortable']/tbody/tr[*]/td[contains(text(),'#{@nameCity}')]/following-sibling::td[6]/a[*]").attribute("href") }
        hrefPUfra=@wait.until { $driver.find_element(:xpath, "//*[contains(text(),'#{@nameCity}')]/following-sibling::*/*/*[@title='Выполнить вход в панель управления: ']/parent::a").attribute("href") }

        #проверка поставщика в созданном франче
        $driver.get hrefPUfra
        @out_file.puts("Шаг #{step+=1} из #{allstep} Перешли в ПУ франча #{@nameCity}")
        findDistr "#{@sitesName} [online]"
        @out_file.puts("Шаг #{step+=1} из #{allstep} Проверили существование поставщика")
        $driver.get @hrefPU
        $driver.find_element(:link_text, 'Клиенты').click
        $driver.find_element(:link_text, 'Франчайзи').click

        fraEdit=@wait.until { $driver.find_element(:xpath, "//*[contains(text(),'#{@nameCity}')]/preceding-sibling::td[@class='talignCenter']/a") }
        fraEdit.click
        @out_file.puts("Шаг #{step+=1} из #{allstep} Открыли франча на редактирование")
             asleep
        puts "#{@conslgreen}Тест по добавлению франча успешно пройден#{@conslwhite}"

   rescue
        @err+=1
        puts "#{@conslred}ERR: Тест не пройден, всё плохо #{@conslwhite}"
        @out_file.puts('ERR: Тест прерван')
    end
    $driver.quit
end
