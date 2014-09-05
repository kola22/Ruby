#!/bin/env ruby
# encoding: utf-8


# Class names must be capitalized.  Technically, it's a constant.
require 'selenium-webdriver'
require '/opt/projects/autotest/Ruby/musthave'
require '/opt/projects/autotest/Ruby/addOrder'
require '/opt/projects/autotest/Ruby/addFranchToPiletskiy'
require '/opt/projects/autotest/Ruby/Addprofile'
require '/opt/projects/autotest/Ruby/addPriceToDistr'
require '/opt/projects/autotest/Ruby/forMcOtzivi'
require '/opt/projects/autotest/Ruby/forMcOtziviShop'
require '/opt/projects/autotest/Ruby/localText'
require '/opt/projects/autotest/Ruby/verifPriceUp'

choiceBrws 1
autharr = ['piletskiy', 'nodakola22', 'piletskiy.abcp.ru']
authPUservice autharr[0], autharr[1], autharr[2], 1
@driver.get @hrefPU
gets
class PageRoute

        def goToRouteList distrName,nameRoute=false
            ###@driver.get @hrefPU
            @driver.find_element(:link_text,'Поставщики').click
            @driver.find_element(:xpath, "//table[*]/tbody/tr[*]/td/span[contains(text(),'#{distrName}')]/../following-sibling::td[2]").click
            if nameRoute
            else
                @driver.find_element(:xpath,"//img[@alt='Редактировать маршрут']").click
            end
        end


        def changeRoute arrToChange
            y=0
            x = arrToChange.size
            while y < x
                @driver.find_element(:name,arrToChange.keys[y]).clear
                puts arrToChange.keys[y]
                puts '_________q___________'
                puts arrToChange.values[y]
                @driver.find_element(:name,arrToChange.keys[y]).send_keys arrToChange.values[y]
                y+=1
            end
        end

end
arrRoute = {'deadline_new' => '3', 'p2_new' => '11'}
route = PageRoute.new
route.goToRouteList 'SjY_PleaseDelMeBro_2014-09-05 09:14:00'
route.changeRoute arrRoute



