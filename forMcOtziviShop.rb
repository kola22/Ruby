#!/bin/env ruby
# encoding: utf-8

## Добавление отзывов к магазу. К тестовому магазу.

require 'selenium-webdriver'
require '/opt/projects/autotest/Ruby/musthave'

def forMcOtziviShop autharr

    begin
        step = 0
        allstep = 13
        puts "#{@conslgreen} Начинаем автотест по добавлению и проверки отзыва к магазину на 4мс #{@conslwhite}"
        @out_file.puts("\n Отчет прохождения теста по добавлению и проверки отзыва к магазину на 4мс")
        i = [1]

            @x=1
            choiceBrws 1
            authPUservice autharr[0], autharr[1], autharr[2], 1
            randomComment = (randomTxt 90) + (randomTxt 90)
            @driver.get 'http://4mycar.ru/shop/43170'



            isElementPresent?(:class, 'tooltipBtn')
            @out_file.puts("Шаг #{step+=1} из #{allstep} Пытаемся добавить отзыв незарегистрированным пользователем")
            @driver.find_element(:xpath, "//*[@value='Написать отзыв']").click
            visibleElement?('Если вы хотите оставить отзыв, войдите в систему или')
            @out_file.puts("Шаг #{step+=1} из #{allstep} Просят залогиниться")
            asleep

            login4mc '+79043459228','kola22'

            @out_file.puts("Шаг #{step+=1} из #{allstep} Входим как клиент на 4мс")
            @driver.get 'http://4mycar.ru/shop/43170'
            isElementPresent?(:xpath, "//*[@value='Изменить отзыв'][@id='editCommentButton']", 'clickAlert')
            @out_file.puts("Шаг #{step+=1} из #{allstep} Меняем отзыв")
            @driver.find_element(:id, 'noteText').clear
            @driver.find_element(:id, 'noteText').send_keys randomComment
            @driver.find_element(:id, 'sendCommentButton').click
            @out_file.puts("Шаг #{step+=1} из #{allstep} Отправляем отзыв")
            asleep
            @driver.get 'http://root.abcp.ru/?page=reviews_approval'
            @out_file.puts("Шаг #{step+=1} из #{allstep} Переходим в  руут и подтверждаем модератором отзыв")
            asleep
            @driver.find_element(:xpath, "//*[contains(text(),'#{randomComment}')]/../following-sibling::*/input[@class='do-approve-rating']").click
            asleep
            @driver.get 'http://root.abcp.ru/?page=reviews_approval'
            if isElementPresentlite(:xpath, "//*[contains(text(),'#{randomComment}')]/../following-sibling::*/input[@class='do-approve-rating']")
                puts 'Отзыв НЕ подтвержден. ОШИБКА'
                @out_file.puts("Шаг #{step+=1} из #{allstep} ERR: Подтверждение провалилось")
            else
                puts 'Подтверждён успешно'
                @out_file.puts("Шаг #{step+=1} из #{allstep} Подтверждение успешно")
            end

            @driver.get 'http://root.abcp.ru/?page=messages_monitor'
            @driver.find_element(:id, 'dateRange').clear
            @driver.find_element(:id, 'dateRange').send_keys "#{Time.now.day}.#{Time.now.month}.#{Time.now.year} - #{Time.now.day}.#{Time.now.month}.#{Time.now.year}"
            @driver.find_element(:name, 'recipient').send_keys 'kola22@mail.ru'
            @driver.find_element(:id, 'mysubmit').click
            if @driver.find_element(:xpath, '//tbody/tr[4]/td[8]').text == 'Ваш отзыв подтвержден модератором на сайте 4mycar.ru'
                puts 'Всё отлично!'
                @out_file.puts("Шаг #{step+=1} из #{allstep} В руте есть информация о письме про отзыв")
            else
                @out_file.puts("Шаг #{step+=1} из #{allstep} ERR: В руте нет информации о письме про отзыв")
            end

            @driver.get 'http://4mycar.ru/shop/43170'
            @out_file.puts("Шаг #{step+=1} из #{allstep} Возвращаемся в карточку магазина на 4мс")
            asleep

        ##############33
        asleep
        isElementPresent?(:class, 'clientNameWrapper')
        asleep
        @driver.find_element(:xpath, "//*[contains(text(),'Выход')]").click
        ## until 4mc error
        ##
            login4mc '+79091234567','398624'    ### autotest@nodapro.tm
            @out_file.puts("Шаг #{step+=1} из #{allstep} Выходим клиентом, заходим сотрудником 4мс")
            @driver.get 'http://4mycar.ru/shop/43170'
            visibleElement?('Ответить',1)
            @driver.find_element(:xpath,"//*[contains(text(),'#{randomComment}')]/../../following-sibling::*/*/*/*/*[contains(text(),'Ответить')]").click
            asleep
            respons ='Нормальный отзыв. Я думал гораздо хуже будет'
            @out_file.puts("Шаг #{step+=1} из #{allstep} Отвечаем на отзыв текстом: #{respons}")
            @driver.find_element(:name,'commentTextarea').send_keys respons
            @driver.find_element(:name,'sendAnswerComment').click
            asleep
            visibleElement?('Ответить',0)
            asleep
            @driver.get 'http://root.abcp.ru/?page=reviews_approval'
            asleep
            @out_file.puts("Шаг #{step+=1} из #{allstep} В root подтверждаем ответ магазина")
            @driver.find_element(:xpath, "//*[contains(text(),'#{randomComment}')]/../../following-sibling::*/*[contains(text(),'#{respons}')]/following-sibling::div[1]/input[@value='Подтвердить']").click


            @driver.get 'http://4mycar.ru/shop/43170'
            @out_file.puts("Шаг #{step+=1} из #{allstep} Проверяем, что 'ответить'  больше не отображается")
            findTextInPage ['Ответить'],1


    rescue
        @err+=1
        a = Time.now.hour.to_s + ':' + Time.now.min.to_s + '_'+Time.now.day.to_s + '_' + Time.now.strftime("%B").to_s
        @driver.save_screenshot("screen/#{a}_ошибка_в_ОТЗЫВЕ_4мс.png")
        puts "#{@conslred}Тест не пройден, всё плохо #{@conslwhite}"
        @out_file.puts('ERR: Тест прерван')
    end

    @driver.quit
end