#!/bin/env ruby
# encoding: utf-8

#Добавление профиля


require '/opt/projects/autotest/Ruby/musthave'


def startTest_addprofile
    begin
        puts "#{@conslgreen}Начинаем АВТОТЕСТ -- добавление профиля#{@conslwhite}"

        i = [1] # в мозиле не может стабильно выбрать родительский профиль ((
        i.each do |q|
            @x = q
            choiceBrws 1
            authPUservice 'piletskiy', 'nodakola22', 'piletskiy.abcp.ru', 1

            # проверяем наличие поставщика, которому будем выставлять наценки
            brandForPriceUp = ['BMW', 'Mahle', 'Knecht']
            distrForPriceUp = 'abcp.ru [online]'
            findDistr distrForPriceUp

            @nameProfile = randomTxt(2) + 'Test' + "_#{Time.now.day}_#{Time.now.month}_#{Time.now.year}"
            addProf @nameProfile, 0
            i=1 # цикл для проверки повторного добавления , но пока он не работает из-за пункта 2 задачи 46423
            loop do
                i=i+1
                addProf @nameProfile, 1 # добавление дочернего профиля
                @driver.find_element(:link_text, 'Профили').click



                #отталкиваемся от имени, так как код у нас с подчеркиванием!
                @driver.find_element(:xpath, "//table[*]/tbody/tr[*]/td[contains(text(),'#{@nameProfile}')]/following-sibling::td[6]/a/img").click
                @driver.find_element(:id, 'popup_msg_ok').click # пытаемся удалить родительский профиль
                findTextInPage ["Невозможно удалить профиль '#{@nameProfile}'.\nКоличество дочерних профилей: 1."]


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
            @driver.find_element(:link_text, 'Профили').click

            while isElementPresentlite(:xpath, "//img[@src='http://admin.abcp.ru/common.images/dtree/nolines_plus.gif']")
                isElementPresent?(:xpath, "//img[@src='http://admin.abcp.ru/common.images/dtree/nolines_plus.gif']")
            end








            @driver.find_element(:xpath, "//*[contains(text(),'#{@ff}')]/following-sibling::*/*/img[@title='Указать наценки по поставщикам']").click
            @driver.find_element(:xpath, "//*[contains(text(),'#{distrForPriceUp}')]/following-sibling::*/*/img[@alt='Редактировать']").click

            findTextInPage brandForPriceUp
            # --- ---- ------ --------- ---------------------
            asleep 3
            @driver.quit
            ## @x=@x+1
        end

        puts "#{@conslgreen}Тест по добавлению профиля успешно пройден#{@conslwhite}"
    rescue
        @err+=1
        a = Time.now.hour.to_s + ':' + Time.now.min.to_s
        @driver.save_screenshot("screen/#{a}_ошибка_в_добавлении_профиля.png")
        puts "#{@conslred}Тест по добавлению профиля _____________не пройден, всё плохо #{@conslwhite}"
    end

end

def startTest_addprofile_toFranch (sitesGk, cityFr)
    begin


#   require '/opt/projects/autotest/Ruby/musthave'
        puts "#{@conslgreen}Начинаем АВТОТЕСТ -- добавление профиля в ПУ франча#{@conslwhite}"

        i = [1] # в мозиле не может стабильно выбрать родительский профиль ((
        i.each do |q|
            @x=q
            choiceBrws 1
            authPUservice 'piletskiy', 'nodakola22', "#{sitesGk}", 1

            @driver.find_element(:link_text, "Клиенты").click
            @driver.find_element(:link_text, "Франчайзи").click

            hrefPUfranch =@driver.find_element(:xpath, "//*[contains(text(),'#{cityFr}')]/following-sibling::*/*/*[@title='Выполнить вход в панель управления: ']/parent::a").attribute("href")
            puts cityFr
            @driver.get hrefPUfranch

            # проверяем наличие поставщика, которому будем выставлять наценки
            brandForPriceUp = ['BMW', 'Mahle', 'Knecht']
            distrForPriceUp = "#{sitesGk}"+' [online]'
            findDistr distrForPriceUp

            @nameProfile = randomTxt(2) + 'Test' + "_#{Time.now.day}_#{Time.now.month}_#{Time.now.year}"
            addProf @nameProfile, 0
            i=1 # цикл для проверки повторного добавления , но пока он не работает из-за пункта 2 задачи 46423
            loop do
                i=i+1
                addProf @nameProfile, 1 # добавление дочернего профиля
                @driver.find_element(:link_text, 'Профили').click
                #отталкиваемся от имени, так как код у нас с подчеркиванием!
                @driver.find_element(:xpath, "//table[*]/tbody/tr[*]/td[contains(text(),'#{@nameProfile}')]/following-sibling::td[6]/a/img").click
                @driver.find_element(:id, 'popup_msg_ok').click # пытаемся удалить родительский профиль
                findTextInPage ['Количество клиентов, которым назначен этот профиль: 1.'] # такое поведение из-за ошибки 46423
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
            @driver.find_element(:link_text, 'Профили').click

            while isElementPresentlite(:xpath, "//img[@src='http://admin.abcp.ru/common.images/dtree/nolines_plus.gif']")
                isElementPresent?(:xpath, "//img[@src='http://admin.abcp.ru/common.images/dtree/nolines_plus.gif']")
            end
            @driver.find_element(:xpath, "//*[contains(text(),'#{@ff}')]/following-sibling::*/*/img[@title='Указать наценки по поставщикам']").click
            @driver.find_element(:xpath, "//*[contains(text(),'#{distrForPriceUp}')]/following-sibling::*/*/img[@alt='Редактировать']").click

            findTextInPage brandForPriceUp
            # --- ---- ------ --------- ---------------------
            asleep 3
            @driver.quit
            @x=@x+1
        end

        puts "#{@conslgreen}Тест по добавлению профиля с наценками у франча успешно пройден#{@conslwhite}"
    rescue
        @err+=1
        a = Time.now.hour.to_s + ':' + Time.now.min.to_s
        @driver.save_screenshot("screen/#{a}_ошибка_в_добавлении_профиля к франчу.png")
        puts "#{@conslred}Тест по добавлению профиля к франчу _____________не пройден, всё плохо #{@conslwhite}"

    end
end
