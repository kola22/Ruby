#!/bin/env ruby
# encoding: utf-8

#Добавление франча
require '/opt/projects/autotest/Ruby/musthave'


def findErrAnnScreeShot autharr
    a = Time.now.hour.to_s + ':' + Time.now.min.to_s + '_'+Time.now.day.to_s + '_' + Time.now.strftime("%B").to_s
    begin
    choiceBrws 1
    authPUservice autharr[0], autharr[1], autharr[2],333
    x=0
    while x<501
        $driver.get "http://www.weloveparts.ru/?page=disks_catalog&action=search&viewMode=tile&property%5Bbrands%5D%5B%5D=REPLICA&property%5Bbrands%5D%5B%5D=Replay&property%5Bbrands%5D%5B%5D=K%26K&property%5Bbrands%5D%5B%5D=MAK&property%5Bbrands%5D%5B%5D=LegeArtis&property%5Bbrands%5D%5B%5D=NZ&property%5Bbrands%5D%5B%5D=SKAD&property%5Bbrands%5D%5B%5D=ALUTEC&property%5Bbrands%5D%5B%5D=FR+Design&property%5Bbrands%5D%5B%5D=iFree&property%5Bdisk_type%5D%5B%5D=forged&property%5Bdisk_type%5D%5B%5D=cast&property%5Bdisk_type%5D%5B%5D=stamped&property%5Bwidth%5D%5B%5D=6&property%5Bwidth%5D%5B%5D=7&property%5Bwidth%5D%5B%5D=8&property%5Bwidth%5D%5B%5D=9.5&property%5Bdiameter%5D%5B%5D=16&property%5Bpcd%5D%5B%5D=114.3&property%5Bet%5D%5Bfrom%5D=-70&property%5Bet%5D%5Bto%5D=150&property%5Bhub_diameter%5D%5Bfrom%5D=40&property%5Bhub_diameter%5D%5Bto%5D=150"
    x=x+1
    end

    rescue
    puts 'сайт лег!'
    $driver.save_screenshot("screen/#{autharr[2]}___#{a}.png")
        if isElementPresent?(:xpath,"//*[contains(text(),'Ошибка')]")
            puts "#{@conslred}ВИДИМ ОШИБКУ#{@conslwhite}"
        end
    end
    $driver.quit
end

def findErrAnnScreeShot2 autharr
    a = Time.now.hour.to_s + ':' + Time.now.min.to_s + '_'+Time.now.day.to_s + '_' + Time.now.strftime("%B").to_s
    if Time.now.min<30
        number = 'http://xn--80aaeu8aipbh1c4c2a.xn--p1ai/?pbrandnumber=OC90&pbrandname=Knecht'
        numberD = 'Knecht'
    else
        number = 'http://xn--80aaeu8aipbh1c4c2a.xn--p1ai/?pbrandnumber=28619&pbrandname=Febi'
        numberD = 'Febi'
    end

    begin


        choiceBrws 1
        authPUservice autharr[0], autharr[1], autharr[2],333
        $driver.get "http://#{autharr[2]}"
        asleep
        $driver.get number
        asleep
        $driver.find_element(:xpath,"//*[contains(text(),'Ожидаемый срок')]")
        # $driver.find_element(:xpath,"//*[contains(text(),'Аналоги')]")
        # $driver.find_element(:xpath,"//*[contains(text(),'Запрашиваемый артикул')]")
        $driver.find_element(:xpath,"//*[contains(text(),'#{numberD}')]")

        $driver.get @hrefPU
        $driver.find_element(:link_text, 'Клиенты').click
        $driver.find_element(:name,'filterCustomersBySearchString').send_keys 'test'
        $driver.find_element(:xpath,"//*[@value='Найти']").click
        asleep
        $driver.find_element(:xpath,"//*[@title='Редактировать информацию о клиенте']").click
        $driver.get $driver.find_element(:class,'linkTempLogin').attribute("href")
        asleep
        $driver.get number
        asleep 5
        $driver.find_element(:xpath,"//*[contains(text(),'Ожидаемый срок')]")
        # $driver.find_element(:xpath,"//*[contains(text(),'Аналоги')]")
        # $driver.find_element(:xpath,"//*[contains(text(),'Запрашиваемый артикул')]")
        $driver.find_element(:xpath,"//*[contains(text(),'#{numberD}')]")


    rescue
        puts 'сайт лег!'
        $driver.save_screenshot("screen/#{autharr[2]}___#{a}.png")
        if isElementPresent?(:xpath,"//*[contains(text(),'Ошибка')]")
            puts "#{@conslred}ВИДИМ ОШИБКУ#{@conslwhite}"
        end
    end
    $driver.quit
end

def findErrAnnScreeShotChida autharr
    begin
        choiceBrws 1
        authPUservice autharr[0], autharr[1], autharr[2],333
        $driver.get @hrefPU
        $driver.find_element(:link_text, 'Клиенты').click
        $driver.find_element(:name,'filterCustomersBySearchString').send_keys 'emex'
        $driver.find_element(:xpath,"//*[@value='Найти']").click
        asleep
        $driver.find_element(:xpath,"//*[@title='Редактировать информацию о клиенте']").click
        $driver.get $driver.find_element(:class,'linkTempLogin').attribute("href")
        asleep
        $driver.find_element(:id, "pcode").send_keys "oc90"
        $driver.find_element(:id, "pcode").submit
        asleep 5
        $driver.find_element(:xpath,"//*[contains(text(),'Запрашиваемый артикул')]")
        $driver.find_element(:xpath,"//*[@value='Выход']").click
        $driver.find_element(:xpath,"//*[contains(text(),'Личный Кабинет')]")
    rescue
        puts 'сайт лег!'
        $driver.save_screenshot("screen/#{autharr[2]}.png")
        if isElementPresent?(:xpath,"//*[contains(text(),'Ошибка')]")
            puts "#{@conslred}ВИДИМ ОШИБКУ#{@conslwhite}"
        end
    end
    $driver.quit
end




