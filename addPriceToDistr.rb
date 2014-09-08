#!/bin/env ruby
# encoding: utf-8

## Добавление прайска к дистрибьютору

require 'selenium-webdriver'
require '/opt/projects/autotest/Ruby/musthave'


def addPriceToDistr autharr,fileName,nameFra=false


    begin
        allstep = 5
        step=0
        if nameFra
            puts "#{@conslgreen} Начинаем автотест по добавлению прайса к дистрибьютору У ФРАНЧА.    file upload: #{fileName} #{@conslwhite}"
            @out_file.puts("\n Отчет прохождения теста по добавлению прайса к дистрибьютору У ФРАНЧА file upload: #{fileName}")
        else
            puts "#{@conslgreen} Начинаем автотест по добавлению прайса к дистрибьютору file upload: #{fileName}#{@conslwhite}"
            @out_file.puts("\n Отчет прохождения теста по добавлению прайса к дистрибьютору file upload: #{fileName}")
        end
            choiceBrws 1
            authPUservice autharr[0], autharr[1], autharr[2], 1

            if nameFra
                $driver.find_element(:link_text, 'Клиенты').click
                $driver.find_element(:link_text, 'Франчайзи').click
                hrefPUfranch =$driver.find_element(:xpath, "//*[contains(text(),'#{nameFra}')]/following-sibling::*/*/*[@title='Выполнить вход в панель управления: ']/parent::a").attribute("href")
                $driver.get hrefPUfranch
            end

            $driver.find_element(:link_text, 'Настройка').click
            $driver.find_element(:link_text, 'Управление почтой').click

            if isElementPresentlite(:xpath, "//*[contains(text(),'EmailEmploynodatest@nodasoft.com')]/following-sibling::td[6]/img")
                puts 'Настройки правильные у сотрудника'
            else
                if isElementPresentlite(:xpath, "//*[contains(text(),'EmailEmploynodatest@nodasoft.com')]")
                    $driver.find_element(:xpath, "//*[contains(text(),'EmailEmploynodatest@nodasoft.com')]/following-sibling::td[9]/a").click
                    $driver.find_element(:name, "distributorUpdate").click
                    $driver.find_element(:xpath, "//*[@*='Сохранить']").click
                else
                $driver.find_element(:link_text, 'Добавить email').click
                $driver.find_element(:name, 'email').send_keys 'EmailEmploynodatest@nodasoft.com'
                $driver.find_element(:name, "distributorUpdate").click
                $driver.find_element(:xpath, "//*[@*='Сохранить']").click
                end
                $driver.find_element(:link_text, 'Настройка').click
                $driver.find_element(:link_text, 'Управление почтой').click
                $driver.find_element(:xpath, "//*[contains(text(),'EmailEmploynodatest@nodasoft.com')]/following-sibling::td[6]/img")
            end

            $driver.find_element(:link_text, 'Поставщики').click
            def delAlldistr(descDist)
                while isElementPresentlite(:xpath,"//span[contains(text(),'#{descDist}')]/../following-sibling::td[5]/a/img")
                    @out_file.puts("Шаг 0.1 из 5 если были выключенные тестовые поставщкии с имененм вида #{descDist}, то мы их удалили")
                        $driver.find_element(:xpath,"//span[contains(text(),'#{descDist}')]/../following-sibling::td[5]/a/img").click
                        $driver.find_element(:id,'popup_msg_ok').click
                        asleep
                end
            end



            ## создаем тестового сотрудника, которому будут отсыласть письма о обновлении прайс листа


            delAlldistr('PleaseDelMeBro')
            ##выключаем всех остальных поставщиков !!
            @out_file.puts("Шаг #{step+=1} из #{allstep} выключаем остальных поставщиков")

            while isElementPresentlite(:xpath, "//span[contains(text(),'Да')]")
                isElementPresent?(:xpath, "//span[contains(text(),'Да')]/following-sibling::*/a[contains(text(),'выкл')]")
            end
            ##

            $driver.find_element(:link_text, 'Добавить поставщика с ручным обновлением').click
            nameDistr = randomTxt(3)+"_PleaseDelMeBro_#{Time.new.strftime('%Y-%m-%d %H:%M:%S')}"
        ##    puts "Имя поставщика #{nameDistr}"
            $driver.find_element(:id, 'addDistributorName').send_keys nameDistr
            $driver.find_element(:id, 'addDistributorDeadline').send_keys '5'
            $driver.find_element(:class, 'ui-button-text').click
            @out_file.puts("Шаг #{step+=1} из #{allstep} Добавили поставщика")
            $driver.find_element(:xpath, "//table[*]/tbody/tr[*]/td/span[contains(text(),'#{nameDistr}')]/../following-sibling::td[7]").click
            $driver.find_element(:name, 'uploadFile').send_keys "/opt/projects/autotest/Ruby/#{fileName}"
            $driver.find_element(:xpath, "//*[@*='saveParamsUpdate']").click
            asleep
            findTextInPage ['Файл поставлен в очередь на обработку'],0
            $driver.find_element(:link_text, 'Конфигурация прайс-листа').click
            arrDistConf = ['Бренд', 'Каталожный номер', 'Описание', 'Наличие', 'Цена']

            z=0 ### это всё Зееееет
            arrDistConf.each do |q|
                $driver.find_element(:xpath, "//*[@id='skipRowsRadio00']/parent::*/following-sibling::*[#{z+=1}]/select/option[contains(text(),'#{q}')]").click
            end
            $driver.find_element(:xpath, "//*[@*='Сохранить']").click
            @out_file.puts("Шаг #{step+=1} из #{allstep} Создали конфигурацию для загрузки прайса поставщика")
            asleep 5
            $driver.find_element(:link_text, 'Загрузка файла').click
            $driver.find_element(:name, 'uploadFile').send_keys "/opt/projects/autotest/Ruby/#{fileName}"
            $driver.find_element(:xpath, "//*[@*='saveParamsUpdate']").click
            findTextInPage ['Файл поставлен в очередь на обработку'],0
            @out_file.puts("Шаг #{step+=1} из #{allstep} Загружаем файл прайса")
            $driver.find_element(:link_text, 'Поставщики').click
            ##   while isElementPresentlite(:xpath, "//*[contains(text(),'Идёт обновление прайс-листа...')]") ## == 'Идёт обновление прайс-листа...'
            ##       $driver.find_element(:link_text, 'Поставщики').click
            ##       asleep 15 , "Ещё не загрузился файл"
            ##   end
            asleep


        $driver.find_element(:xpath, "//table[*]/tbody/tr[*]/td/span[contains(text(),'#{nameDistr}')]/../following-sibling::*/a[contains(text(),'вкл')]").click



            @out_file.puts("Шаг #{step+=1} из #{allstep} Включаем добавленного поставщика")



            @nameDistr << nameDistr
        rescue
        @err+=1
        @out_file.puts("ERR")
        ###a = Time.now.hour.to_s + ':' + Time.now.min.to_s
        ### $driver.save_screenshot("screen/#{a}_ошибка_в_добавлении_прайса.png")
        if nameFra
            puts "#{@conslred}Тест Добавления прайска к поставщику на ФРАНЧЕ не пройден, всё плохо file upload: #{fileName}#{@conslwhite}"
        else
            puts "#{@conslred}Тест Добавления прайска к поставщику на ГК не пройден, всё плохо file upload: #{fileName} #{@conslwhite}"
        end
        @out_file.puts('ERR: тест прерван')
    end
    $driver.quit
end
