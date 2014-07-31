#!/bin/env ruby
# encoding: utf-8

#Добавление профиля


require '/opt/projects/autotest/Ruby/musthave'


def startTest_addprofile autharr
    begin
        step = 0
        allstep = 6
        @out_file.puts("\n Отчет прохождения теста по добавлению профиля")
        puts "#{@conslgreen}Начинаем АВТОТЕСТ -- добавление профиля#{@conslwhite}"

            choiceBrws 1
            authPUservice autharr[0], autharr[1], autharr[2], 1

               ########## Удаление лишних профилей ##########
               ## i =1
               ##@driver.get 'http://cp.abcp.ru/?page=customers&profiles'
               ##loop do
               ##while  isElementPresentlite(:xpath, "//img[@src='http://admin.abcp.ru/common.images/dtree/nolines_plus.gif']")
               ##isElementPresent?(:xpath, "//img[@src='http://admin.abcp.ru/common.images/dtree/nolines_plus.gif']")
               ##end
               ##@driver.find_element(:xpath, "//*[contains(text(),'Test')]/../*/a/img[@alt='Удалить профиль']").click
               ##@driver.find_element(:id,'popup_msg_ok').click
               ##break if i == 3
               ##end

            # проверяем наличие поставщика, которому будем выставлять наценки
            brandForPriceUp = ['BMW', 'Mahle', 'Knecht']
            distrForPriceUp = 'abcp.ru [online]'
            findDistr distrForPriceUp
            @out_file.puts("Шаг #{step+=1} из #{allstep} Проверяем включенность дистрибьютора")
            @nameProfile = randomTxt(2) + 'Test' + "_#{Time.now.day}_#{Time.now.month}_#{Time.now.year}"
            addProf @nameProfile, 0
            @out_file.puts("Шаг #{step+=1} из #{allstep} Добавляем профиль")
            i=1 # цикл для проверки повторного добавления , но пока он не работает из-за пункта 2 задачи 46423


            loop do
                i=i+1
                addProf @nameProfile, 1 # добавление дочернего профиля
                @out_file.puts("Шаг #{step+=1} из #{allstep} Добавляем дочерний профиль")
                @driver.find_element(:link_text, 'Профили').click
                #отталкиваемся от имени, так как код у нас с подчеркиванием!
                @driver.find_element(:xpath, "//table[*]/tbody/tr[*]/td[contains(text(),'#{@nameProfile}')]/following-sibling::td[6]/a/img").click
                @driver.find_element(:id, 'popup_msg_ok').click # пытаемся удалить родительский профиль
                findTextInPage ["Невозможно удалить профиль '#{@nameProfile}'.\nКоличество дочерних профилей: 1."]
                @out_file.puts("Шаг #{step+=1} из #{allstep} пытаемся удалить родительский профиль ")
                ## Удаляем все дочерние профили
                @ff = 'comment+'+@nameProfile+'doch'
                if i == 1 # удаляем только при первом добавлении

                    while isElementPresentlite(:xpath, "//img[@src='http://admin.abcp.ru/common.images/dtree/nolines_plus.gif']")
                        isElementPresent?(:xpath, "//img[@src='http://admin.abcp.ru/common.images/dtree/nolines_plus.gif']")
                    end

                    puts @ff
                    @wait.until { @driver.find_element(:xpath, "//table[*]/tbody/tr[*]/td[contains(text(),'#{@ff}')]/following-sibling::td[5]/a/img") }.click
                    @driver.find_element(:id, 'popup_msg_ok').click
                end
                break if i==2
            end
            # выставляем наценки в родительском профиле и проверяем, что они выставились в дочернем
            AddPriceUpBrand brandForPriceUp, @nameProfile, distrForPriceUp
            @out_file.puts("Шаг #{step+=1} из #{allstep} добавляем наценки в родительском профиле ")
            @driver.find_element(:link_text, 'Профили').click

            while isElementPresentlite(:xpath, "//img[@src='http://admin.abcp.ru/common.images/dtree/nolines_plus.gif']")
                isElementPresent?(:xpath, "//img[@src='http://admin.abcp.ru/common.images/dtree/nolines_plus.gif']")
            end

            @driver.find_element(:xpath, "//*[contains(text(),'#{@ff}')]/following-sibling::*/*/img[@title='Указать наценки по поставщикам']").click
            @driver.find_element(:xpath, "//*[contains(text(),'#{distrForPriceUp}')]/following-sibling::*/*/img[@alt='Редактировать']").click
            @out_file.puts("Шаг #{step+=1} из #{allstep} проверяем что они выставились в дочернем ")
            findTextInPage brandForPriceUp
            asleep
            @driver.quit


        puts "#{@conslgreen}Тест по добавлению профиля успешно пройден#{@conslwhite}"
    rescue
        @err+=1

        a = Time.now.hour.to_s + ':' + Time.now.min.to_s
        @driver.save_screenshot("screen/#{a}_ошибка_в_добавлении_профиля.png")
        puts "#{@conslred}Тест по добавлению профиля _____________не пройден, всё плохо #{@conslwhite}"
        @out_file.puts('ERR: Тест прерван')
    end

end

def startTest_addprofile_toFranch autharr, cityFr
    begin
        step = 0
        allstep = 7

#   require '/opt/projects/autotest/Ruby/musthave'
        puts "#{@conslgreen}Начинаем АВТОТЕСТ -- добавление профиля в ПУ франча#{@conslwhite}"
        @out_file.puts("\n Отчет прохождения теста по добавлению профиля в ПУ франча")
            choiceBrws 1
            authPUservice autharr[0], autharr[1], autharr[2], 1
            @driver.find_element(:link_text, "Клиенты").click
            @driver.find_element(:link_text, "Франчайзи").click
            hrefPUfranch =@driver.find_element(:xpath, "//*[contains(text(),'#{cityFr}')]/following-sibling::*/*/*[@title='Выполнить вход в панель управления: ']/parent::a").attribute("href")
            puts cityFr
            @out_file.puts("Шаг #{step+=1} из #{allstep} Переходим в ПУ франча")
            @driver.get hrefPUfranch
            # проверяем наличие поставщика, которому будем выставлять наценки
            brandForPriceUp = ['BMW', 'Mahle', 'Knecht']
            distrForPriceUp = "#{autharr[2]}"+' [online]'
            findDistr distrForPriceUp
            @out_file.puts("Шаг #{step+=1} из #{allstep} Проверяем включенность дистрибьютора ГК у франча")
            @nameProfile = randomTxt(2) + 'Test' + "_#{Time.now.day}_#{Time.now.month}_#{Time.now.year}"
            addProf @nameProfile, 0
            @out_file.puts("Шаг #{step+=1} из #{allstep} Добавляем профиль")
            i=0 # цикл для проверки повторного добавления , но пока он не работает из-за пункта 2 задачи 46423
            loop do
                i=i+1
                addProf @nameProfile, 1 # добавление дочернего профиля
                @out_file.puts("Шаг #{step+=1} из #{allstep} Добавляем дочерний профиль")
                @driver.find_element(:link_text, 'Профили').click
                #отталкиваемся от имени, так как код у нас с подчеркиванием!
                @driver.find_element(:xpath, "//table[*]/tbody/tr[*]/td[contains(text(),'#{@nameProfile}')]/following-sibling::td[6]/a/img").click
                @driver.find_element(:id, 'popup_msg_ok').click # пытаемся удалить родительский профиль
                ##№№findTextInPage ['Количество клиентов, которым назначен этот профиль: 1.'] # такое поведение из-за ошибки 46423
                @out_file.puts("Шаг #{step+=1} из #{allstep} пытаемся удалить родительский профиль ")
                @ff = 'comment+'+@nameProfile+'doch'
                if i == 1 # удаляем только при первом добавлении

                    while isElementPresentlite(:xpath, "//img[@src='http://admin.abcp.ru/common.images/dtree/nolines_plus.gif']")
                        isElementPresent?(:xpath, "//img[@src='http://admin.abcp.ru/common.images/dtree/nolines_plus.gif']")
                    end
                    puts @ff
                    @wait.until { @driver.find_element(:xpath, "//table[*]/tbody/tr[*]/td[contains(text(),'#{@ff}')]/following-sibling::td[5]/a/img") }.click
                    @driver.find_element(:id, 'popup_msg_ok').click
                end
                break if i==2
            end
            # выставляем наценки в родительском профиле и проверяем, что они выставились в дочернем
            AddPriceUpBrand brandForPriceUp, @nameProfile, distrForPriceUp
            @out_file.puts("Шаг #{step+=1} из #{allstep} добавляем наценки в родительском профиле ")
            @driver.find_element(:link_text, 'Профили').click

            while isElementPresentlite(:xpath, "//img[@src='http://admin.abcp.ru/common.images/dtree/nolines_plus.gif']")
                isElementPresent?(:xpath, "//img[@src='http://admin.abcp.ru/common.images/dtree/nolines_plus.gif']")
            end
            @driver.find_element(:xpath, "//*[contains(text(),'#{@ff}')]/following-sibling::*/*/img[@title='Указать наценки по поставщикам']").click
            @driver.find_element(:xpath, "//*[contains(text(),'#{distrForPriceUp}')]/following-sibling::*/*/img[@alt='Редактировать']").click
            @out_file.puts("Шаг #{step+=1} из #{allstep} проверяем что они выставились в дочернем ")
            findTextInPage brandForPriceUp
            asleep
            @driver.quit



        puts "#{@conslgreen}Тест по добавлению профиля с наценками у франча успешно пройден#{@conslwhite}"
    rescue
        @err+=1
       ## a = Time.now.hour.to_s + ':' + Time.now.min.to_s
        @out_file.puts('ERR: Тест прерван')
       ### @driver.save_screenshot("screen/#{a}_ошибка_в_добавлении_профиля к франчу.png")
        puts "#{@conslred}Тест по добавлению профиля к франчу _____________не пройден, всё плохо #{@conslwhite}"

    end
end
