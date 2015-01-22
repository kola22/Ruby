#!/bin/env ruby
# encoding: utf-8

#Проверка локализованных текстов. В частности доработка "2037"
require '/opt/projects/autotest/Ruby/musthave'

## Нужно организовать проверку на ГК,франче и на их сайтах
##

##
##


def localText autharr,nameFra
    puts "#{$conslgreen}Начинаем АВТОТЕСТ -- проверка локализованных текстов в связки с франч<>ГК#{$conslwhite}"
    $out_file.puts("\n Отчет прохождения теста проверки локализованных текстов в связки с франч<>ГК")
    step = 0
    allstep = 12
    begin
        choiceBrws 1
        authPUservice autharr[0], autharr[1], autharr[2], 1

        $driver.find_element(:link_text,'Персонал').click
        hrefPUGK = $driver.find_element(:xpath, "//*[contains(text(),'admin')]/following-sibling::td[11]/a").attribute("href")
        hrefPUGK = lanUrl hrefPUGK
        hrefSiteGK = $driver.find_element(:xpath, "//*[contains(text(),'admin')]/following-sibling::td[12]/a").attribute("href")
        hrefSiteGK = lanUrl hrefSiteGK

        ##$driver.get hrefPUGK
        $driver.find_element(:link_text,'Клиенты').click
        $driver.find_element(:link_text,'Франчайзи').click

        hrefPUfranch =$driver.find_element(:xpath, "//*[contains(text(),'#{nameFra}')]/following-sibling::*/*/*[@title='Выполнить вход в панель управления: ']/parent::a").attribute("href")
        hrefPUfranch = lanUrl hrefPUfranch
        hrefSiteFranch = $driver.find_element(:xpath, "//*[contains(text(),'#{nameFra}')]/following-sibling::*/*/*[@title='Выполнить вход на сайт: ']/parent::a").attribute("href")
        hrefSiteFranch = lanUrl hrefSiteFranch

        ##$driver.get hrefPUfranch``
        $out_file.puts("Шаг #{step+=1} из #{allstep} Набираем ссылки для входа в ПУ и на сайт ГК / франча")
        varToText = randomTxt(10)


        def delLocalText urlPU,blokToChange,local=false
            $driver.get urlPU
            $driver.find_element(:link_text,'Внешний вид и контент').click
            $driver.find_element(:link_text,'Текстовые сообщения').click
            $driver.find_element(:name, 'selectedCategory').click
            asleep
            $driver.find_elements(:tag_name => 'option').find do |option|
                option.text == blokToChange
            end.click
            $driver.find_element(:xpath, "//*[@value='Найти']").click

            if local
                $driver.find_element(:name, 'selectedLocale').click
                $driver.find_element(:xpath, "//select[@name='selectedLocale']/option[contains(text(),'#{local}')]").click
                puts local
               ## $driver.find_element(:name, 'selectedLocale').click
               ## $driver.find_elements(:tag_name => 'option').find do |option|
               ##     option.text == local
               ## end.click
            end
            $driver.find_element(:xpath, "//*[@value='Найти']").click

            while   isElementPresentlite(:xpath,"//*[@title='Удалить собственное значение']")
                $driver.find_element(:xpath,"//*[@title='Удалить собственное значение']").click
                $driver.find_element(:id, 'popup_msg_ok').click
                asleep 2
            end
            while isElementPresentlite(:class,'nextPage')
                $driver.find_element(:class,'nextPage').click
                while   isElementPresentlite(:xpath,"//*[@title='Удалить собственное значение']")
                    $driver.find_element(:xpath,"//*[@title='Удалить собственное значение']").click
                    $driver.find_element(:id, 'popup_msg_ok').click
                    asleep 2
                end
            end

        end



        def verifLocalInPUfranch franchHref,blokToChange,naborToChange,whatVerif,local
            asleep
            $driver.get franchHref
            $driver.find_element(:link_text,'Внешний вид и контент').click
            $driver.find_element(:link_text,'Текстовые сообщения').click
            $driver.find_element(:name, 'selectedCategory').click
            asleep
            $driver.find_elements(:tag_name => 'option').find do |option|
                option.text == blokToChange
            end.click
            $driver.find_element(:name, 'selectedLocale').click
            $driver.find_element(:xpath, "//select[@name='selectedLocale']/option[contains(text(),'#{local}')]").click

            $driver.find_element(:xpath, "//*[@value='Найти']").click
            if whatVerif == $driver.find_element(:xpath, "//*[contains(text(),'#{naborToChange}')]/following-sibling::td[1]").text
            else
                puts 'err'
                $err+=1
            end

        end


        def changelocaltext blokToChange,naborToChange,varToText,needGoFrach=false,localToChange=false

            if needGoFrach
                $driver.get needGoFrach
            end
            $driver.find_element(:link_text,'Внешний вид и контент').click
            $driver.find_element(:link_text,'Текстовые сообщения').click
            $driver.find_element(:name, 'selectedCategory').click
            asleep
            $driver.find_elements(:tag_name => 'option').find do |option|
                option.text == blokToChange
            end.click
            $driver.find_element(:xpath, "//*[@value='Найти']").click

            if localToChange
                $driver.find_element(:name, 'selectedLocale').click
                $driver.find_element(:xpath, "//select[@name='selectedLocale']/option[contains(text(),'#{localToChange}')]").click
            end
            $driver.find_element(:xpath, "//*[@value='Найти']").click
        if needGoFrach
        else
            @defVarLocal=$driver.find_element(:xpath, "//*[contains(text(),'#{naborToChange}')]/following-sibling::td[1]").text
        end

        $driver.find_element(:xpath, "//*[contains(text(),'#{naborToChange}')]/following-sibling::td[4]/img").click

        $driver.find_element(:name, 'useDefault').click
        $driver.find_element(:id,'mceEditor').clear
        $driver.find_element(:id,'mceEditor').send_key varToText
        asleep
        $driver.find_element(:xpath, "//span[contains(text(),'Сохранить')]").click
        asleep
        end

        def proverkaLocatText siteUrl,verifText,changeLocal
                $driver.get siteUrl
                $driver.find_element(:xpath, "//ul[@class='languagesList']/li/a[contains(text(),'#{changeLocal}')]").click
                $driver.find_element(:id, "pcode").send_keys "oc90"
                $driver.find_element(:xpath, "//*[@value='Найти']").click
                $driver.find_element(:xpath, "//*[contains(text(),'#{verifText}')]").click
                asleep
                $driver.find_element(:xpath, "//*[contains(text(),'#{verifText}')]").click
        end

        $out_file.puts("Шаг #{step+=1} из #{allstep} Удаляем все выставленные значения локализации на франче и на ГК")
        puts hrefPUfranch
        delLocalText hrefPUfranch,'Блок управления сортировкой'
        delLocalText hrefPUGK,'Блок управления сортировкой'

        $out_file.puts("Шаг #{step+=1} из #{allstep} Выставляем значение #{varToText} в Русскую локаль на ГК")
        changelocaltext 'Блок управления сортировкой','by_availability',varToText,false,'Русский Россия'
        $out_file.puts("Шаг #{step+=1} из #{allstep} Проверяем выставленное значение в ПУ франча. В столбце ПОУМОЛЧАНИЮ отображается только что внесенное значение с ГК")
        puts hrefPUfranch
        verifLocalInPUfranch hrefPUfranch,'Блок управления сортировкой','by_availability',varToText,'Русский Россия'

        $out_file.puts("Шаг #{step+=1} из #{allstep} Запускаем проверки на сайте как под ГК , так и под франчевым клиентом")
        proverkaLocatText hrefSiteGK,varToText,'ru'
        proverkaLocatText hrefSiteGK,varToText,'te'
        proverkaLocatText hrefSiteFranch,varToText,'ru'
        proverkaLocatText hrefSiteFranch,varToText,'te'

        varToText2 = randomTxt(10) + '____FRA'
        $out_file.puts("Шаг #{step+=1} из #{allstep} Генерим новое значения для локализации франча #{varToText2}")

        $out_file.puts("Шаг #{step+=1} из #{allstep} И выставляем это новое значение в ПУ франча")
        changelocaltext 'Блок управления сортировкой','by_availability',varToText2,hrefPUfranch,'Русский Россия'
        $out_file.puts("Шаг #{step+=1} из #{allstep} Проверяем, что на сайте франча отображается новое значение, а на сайте ГК старое")
        proverkaLocatText hrefSiteGK,varToText,'ru'
        proverkaLocatText hrefSiteFranch,varToText2,'ru'
        proverkaLocatText hrefSiteGK,varToText,'te'
        proverkaLocatText hrefSiteFranch,varToText2,'te'

        $out_file.puts("Шаг #{step+=1} из #{allstep} Удаляем выставленное значение у франча")
        delLocalText hrefPUfranch,'Блок управления сортировкой'
        $out_file.puts("Шаг #{step+=1} из #{allstep} Проверяем что на сайте франча, теперь отображается значение из ГК")
        proverkaLocatText hrefSiteFranch,varToText,'ru'
        proverkaLocatText hrefSiteFranch,varToText,'te'
        $out_file.puts("Шаг #{step+=1} из #{allstep} Удаляем выставленное значение в ПУ ГК")
        delLocalText hrefPUGK,'Блок управления сортировкой'

        $out_file.puts("Шаг #{step+=1} из #{allstep} Проверяем, что и на сайте ГК и на сайте франча отображатеся дефолтное значение локали, выставленное в руте")
        proverkaLocatText hrefSiteGK,@defVarLocal,'ru'
        proverkaLocatText hrefSiteGK,@defVarLocal,'te'
        proverkaLocatText hrefSiteFranch,@defVarLocal,'ru'
        proverkaLocatText hrefSiteFranch,@defVarLocal,'te'

        ## test lan
        rescue
        $err+=1
        $out_file.puts('ERR: Тест прерван')
        ### $driver.save_screenshot("screen/#{a}_ошибка_в_добавлении_профиля к франчу.png")
        puts "#{$conslred}Тест по проверке локализаций ГК<>Франч не пройден#{$conslwhite}"
    end
    $driver.quit
end