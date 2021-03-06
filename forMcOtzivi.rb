#!/bin/env ruby
# encoding: utf-8

## Добавление прайска к дистрибьютору

require 'selenium-webdriver'
require '/opt/projects/autotest/Ruby/musthave'

def forMcOtzivi autharr
    step =0
    allstep=8

    puts "#{@conslgreen} Начинаем автотест по добавлению и проверки отзыва на 4мс #{@conslwhite}"
    @out_file.puts("\n Отчет прохождения теста по добавлению и проверки отзыва на 4мс")
    begin

            choiceBrws 1
            authPUservice autharr[0], autharr[1], autharr[2], 1
            randomComment = (randomTxt 90) + (randomTxt 90)
            $driver.get "http://4mycar.ru"
            @out_file.puts("Шаг #{step+=1} из #{allstep} Успешно перешли на 4мс")

            isElementPresent?(:class, 'tooltipBtn')
            asleep
            login4mc '+79043459228','846952'

            element = $driver.find_element :name => 'pcode'
            @out_file.puts("Шаг #{step+=1} из #{allstep} Успешно авторизовались")
            element.send_keys '724531366'
            element.submit
            $driver.find_element(:link_text, 'Отзывы').click
            isElementPresent?(:xpath, "//*[@value='Изменить отзыв'][@id='editCommentButton']", 'clickAlert')
            $driver.find_element(:id, 'noteText').clear
            $driver.find_element(:id, 'noteText').send_keys randomComment
            $driver.find_element(:id, 'sendCommentButton').click
            asleep
            @out_file.puts("Шаг #{step+=1} из #{allstep} Изменили и отослали отзыв")
            $driver.get 'http://root.abcp.ru/?page=reviews_approval'
            asleep 3
            $driver.find_element(:xpath, "//*[contains(text(),'#{randomComment}')]/../following-sibling::*/input[@class='do-approve-rating']").click
            asleep 3
            $driver.get 'http://root.abcp.ru/?page=reviews_approval'
            if isElementPresentlite(:xpath, "//*[contains(text(),'#{randomComment}')]/../following-sibling::*/input[@class='do-approve-rating']")
                puts 'Отзыв НЕ подтвержден. ОШИБКА'
            else
                puts 'Подтверждён успешно'
                @out_file.puts("Шаг #{step+=1} из #{allstep} Подтвердили отзыв модератором на 4мс")
            end
            timeDMY = "#{Time.now.day}.#{Time.now.month}.#{Time.now.year}"
            messagesUrl = "http://root.abcp.ru/?page=messages_monitor&dateRange=#{timeDMY}"
            # messagesUrl = "http://root.abcp.ru/?page=messages_monitor&dateRange=#{Time.now.day}.#{Time.now.month}.#{Time.now.year}"
            $driver.get messagesUrl
            $driver.find_element(:name, 'recipient').send_keys 'kola22@mail.ru'
            $driver.find_element(:id, 'mysubmit').click
            if $driver.find_element(:xpath, '//tbody/tr[4]/td[8]').text == 'Ваш отзыв подтвержден модератором на сайте 4mycar.ru'
                @out_file.puts("Шаг #{step+=1} из #{allstep} Проверили отсылку письма от модератора")
            end
            $driver.get 'http://4mycar.ru/parts/testBrand/724531366'
            $driver.find_element(:link_text, 'Отзывы').click

            asleep 7
            if isElementPresentlite(:xpath, "//div/span/span[contains(text(),'На проверке')]")
               ## puts 'Проблема, до сих пор отображается На проверки у модератора'
                @out_file.puts("ERR:#{step+=1} из #{allstep} Проблема, до сих пор отображается На проверки у модератора")
            else
           ##     puts 'Нет проблем, проверки у модератора не отображается '
                @out_file.puts("Шаг #{step+=1} из #{allstep} Проверки у модератора не отображается на странице 4мс с отзывом ")
            end

            isElementPresent?(:xpath, "//*[@value='Изменить отзыв'][@id='editCommentButton']", 'clickAlert')
            $driver.find_element(:id, 'noteText').clear
            $driver.find_element(:id, 'noteText').send_keys randomComment
            $driver.find_element(:id, 'sendCommentButton').click
            asleep 5
            $driver.get 'http://root.abcp.ru/?page=reviews_approval'
            $driver.find_element(:xpath, "//*[contains(text(),'#{randomComment}')]/../following-sibling::*/input[@class='do-decline-rating']").click
            $driver.find_element(:class, 'reasonText').send_keys 'Потому что тест, вот почему'
            $driver.find_element(:name, 'sendReasonComment').click
            asleep 5
            $driver.get 'http://root.abcp.ru/?page=reviews_approval'
            if isElementPresentlite(:xpath, "//*[contains(text(),'#{randomComment}')]/../following-sibling::*/input[@class='do-decline-rating']")
              ##  puts 'Отзыв НЕ отклонён. ОШИБКА'
                @out_file.puts("ERR: Шаг #{step+=1} из #{allstep} Отзыв НЕ отклонён.")
            else
             ##   puts 'Отклонён успешно'
                @out_file.puts("Шаг #{step+=1} из #{allstep} Отклонён успешно")
            end

            $driver.get messagesUrl
            $driver.find_element(:name, 'recipient').send_keys 'kola22@mail.ru'
            $driver.find_element(:id, 'mysubmit').click
            if $driver.find_element(:xpath, '//tbody/tr[4]/td[8]').text == 'Ваш отзыв отклонен модератором на сайте 4mycar.ru'
                @out_file.puts('Шаг 8 из 8 Успешно послано письмо о отклонении модератором отзыва')
            end

    rescue
        @err+=1
        a = Time.now.hour.to_s + ':' + Time.now.min.to_s
        ##$driver.save_screenshot("screen/#{a}_ошибка_в_ОТЗЫВЕ_4мс.png")
        puts "#{@conslred}ERR: Тест не пройден, всё плохо #{@conslwhite}"
        @out_file.puts('ERR: Тест прерван')
    end
    $driver.quit
end