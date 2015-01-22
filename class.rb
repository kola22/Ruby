#!/bin/env ruby
# encoding: utf-8

class ChoiceBrowser
    def choiceBrws (max=1)

        @x =1 ## хром
        if @x== 1
            ##       brws = "хроме"
            caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {"args" => ["test-type" ]})
            $driver = Selenium::WebDriver.for :chrome,desired_capabilities:caps
        else
            ##       brws = "мозиле"
            $driver = Selenium::WebDriver.for :ff
        end
        ##   puts "#{$conslgreen} работает в #{brws} #{$conslwhite}"
        if !@lan
            $driver.manage.timeouts.implicit_wait = 10 # seconds
        else
            $driver.manage.timeouts.implicit_wait = 60 # seconds
        end

        if max == 1
            $driver.manage.window.maximize
        end

    end
    choiceBrws
end

