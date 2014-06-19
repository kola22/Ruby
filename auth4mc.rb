#!/bin/env ruby
# encoding: utf-8
require '/opt/projects/autotest/Ruby/musthave'
require 'selenium-webdriver'

arrlog = ['kola22@mail.ru', 'dolgopolov-kb@mail.ru', 'bifitor@yandex.ru']
arrpass = ['kola22', 'kot2658511', 'bytnpfrfp']
wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds


def choiceBrws

    if @x== 0
        @driver = Selenium::WebDriver.for :chrome
        puts "работает в хроме"
    else
        puts "работаем в мозиле"
        @driver = Selenium::WebDriver.for :ff


    end
end


##@name = "Понятно"
@x=0
while @x<2
    choiceBrws
    @driver.manage.window.maximize
    #@driver.manage.timeouts.implicit_wait = 10 # seconds

    i=0
    while i < 2
        @driver.get "http://4mycar.ru"
        sleep 3
        @driver.save_screenshot("/screen/#{@x}#{i}.png")
        puts "0"
        sleep 3
        poniatno
        sleep 3
        element = @driver.find_element :id => 'loginEnter'
        element.click

        login = wait.until { @driver.find_element :id => 'login' }
        login.send_keys arrlog[i]
        pass = wait.until { @driver.find_element :id => 'pass' }
        pass.send_keys arrpass[i]

        element = @driver.find_element :class => 'authBottom'
        element.submit

        puts "1"

        element = @driver.find_element :name => "pcode"
        element.send_keys "oc90"
        element.submit

        puts "2"

        profile = wait.until { @driver.find_element :class => 'clientNameWrapper' }
        profile.click

        puts "2.1"
        sleep 3

        logout = wait.until { @driver.find_element :id => 'logout' }
        logout.click
        element = wait.until { @driver.find_element :id => 'loginEnter' }

        sleep 3

        poniatno

        puts "3"

        i=i+1

    end

    @driver.quit
    @x=@x+1

end

sleep 5
puts "successful"