#!/bin/env ruby
# encoding: utf-8

require 'selenium-webdriver'
require 'clipboard'
require 'nokogiri'
require 'open-uri'

@conslgreen = "\x1b[1;32m "
@conslwhite = "\x1b[0m"
@conslred = "\x1b[1;31m"
@consfiolet = "\x1b[35m"

@wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
# авторизация

def lanUrl urlTolan

    if @lan and !urlTolan.match(/.lan\W{2}/)
        firspart = urlTolan.match(/.*(?=.\?tlogin.*)/)
        secondpart = urlTolan.match(/.\?tlogin.*/)
        lanUrl= firspart.to_s + '.lan' + secondpart.to_s
    else
        lanUrl = urlTolan
    end
    return lanUrl
end

def authPUservice (login, password, sitesttogo, goservice=1)

    $driver.get "http://root.abcp.ru#{@lan}"
    golog = $driver.find_element(:class => 'inp')
    golog.send_keys (login)
    pass = $driver.find_element(:name => 'pass')
    pass.send_keys (password)
    $driver.find_element(:name => 'go').click
    if goservice == 1
        $driver.get "http://root.abcp.ru#{@lan}/?page=customers&letter=service"
    elsif goservice == 0
        $driver.get "http://root.abcp.ru#{@lan}/?page=customers&letter=all"
    elsif goservice == 333
        $driver.find_element(:id,'search').send_keys sitesttogo
        $driver.find_element(:xpath,"//input[@value='Найти']").click
    end
    @hrefPU=$driver.find_element(:link_text, (sitesttogo)).attribute("href")
    $driver.get lanUrl @hrefPU
    @sitesName = sitesttogo
end

# выбор браузера
def choiceBrws (max=1)
    @x =1 ## пока только хром, мозила не интересна
    if @x== 1
 ##       brws = "хроме"
        caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {"args" => ["test-type" ]})
        $driver = Selenium::WebDriver.for :chrome,desired_capabilities:caps
    else
 ##       brws = "мозиле"
        $driver = Selenium::WebDriver.for :ff
    end
 ##   puts "#{@conslgreen} работает в #{brws} #{@conslwhite}"
    if !@lan
        $driver.manage.timeouts.implicit_wait = 10 # seconds
    else
        $driver.manage.timeouts.implicit_wait = 60 # seconds
    end

    if max == 1
        $driver.manage.window.maximize
    end

end

# поиск текста на странице
def findTextInPage(arrtext, needPuts =1)
    arrtext.each do |i|
        begin
            @wait.until { $driver.find_element(:tag_name => "body").text.include?(i) }

            if  i == "Ошибка"
                puts "#{@conslred}НА СТРАНИЦЕ ОШИБКА!!!!!!!!!!!!!!!!!!!!!!!!!1#{@conslwhite}"
            end
            if  needPuts == 1
                puts "Такой текст есть на странице:   #{i} "
            end
        rescue
            @out_file.puts("\n\nОжидаемого текста не было: #{i} \n\n ")
            puts "Такого текста нет на странице:    #{i}"
        end
    end
end

# поиск элемента на странице
def isElementPresentlite(type, selector)
    ##begin
        $driver.find_element(type, selector)
        sleep 0.1
    rescue
end

def isElementPresent?(type, selector, whatNeedToDo="Ничего не делаем")
        $driver.find_element(type, selector).click
        case whatNeedToDo
            when "clickAlert"
                $driver.switch_to.alert.accept
            else
        end
        sleep 0.1
    rescue

end


def randomTxt (count)
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    return string = (0...(count)).map { o[rand(o.length)] }.join
end

# поиск поставщика
def findDistr (nameDistr)
    begin
    $driver.find_element(:link_text, 'Поставщики').click
    if  $driver.find_element(:xpath, "//table[*]/tbody/tr[*]/td/span[contains(text(),'#{nameDistr}')]/../following-sibling::td[4]").text=="Нет (вкл)"
        puts "этот поставщик выключен"
    else
        puts "Этот поставщик подключен. Всё #{@conslgreen}норм,#{@conslwhite} расслабся"
    end
    rescue
        puts "#{@conslred} При поиске поставщика возникли оишбки!!!#{@conslwhite}"
    end
end

#добавление профиля
def addProf (codeprof, ifdoch,notRand=false)

    $driver.find_element(:link_text, 'Клиенты').click
    $driver.find_element(:link_text, 'Профили').click

    $driver.find_element(:link_text, 'Добавить профиль').click
    if ifdoch == 1
        asleep 2
        $driver.find_element(:name, 'baseProfileId').click
        asleep 1
        $driver.find_elements(:tag_name => 'option').find do |option|
            option.text == codeprof.to_s
        end.click
        ddd = 'doch'
    else
        ddd = ''
    end
    asleep 1
    $driver.find_element(:name, 'code').send_keys ddd+codeprof+ddd
    $driver.find_element(:name, 'name').send_keys ddd+codeprof+ddd
    $driver.find_element(:name, 'comment').send_keys 'comment+'+codeprof+ddd
    if !notRand
    $driver.find_element(:xpath, "//table[@id='editProfileTbl']/tbody/tr[*]/th[contains(text(),'%')]/following-sibling::td[*]/input").send_keys rand(-900..900).to_s
    else
        $driver.find_element(:xpath, "//table[@id='editProfileTbl']/tbody/tr[*]/th[contains(text(),'%')]/following-sibling::td[*]/input").send_keys notRand
    end

    $driver.find_element(:xpath, '//td[@class="ralignRight"]/input[@value="Сохранить"]').click
    @wait.until { $driver.find_element(:id, 'popup_msg_ok') }.click

    puts "Добавили профиль с кодом #{codeprof}"+ddd

end

#добавление наценки на бренда в профиле
def AddPriceUpBrand (arrBrand, nameProfile, findD, priceUp=false)
    i=(arrBrand.count)
    x3=0
    $driver.find_element(:link_text, 'Клиенты').click
    $driver.find_element(:link_text, 'Профили').click
# раскрываем весь список профилей! нажимаем на плюсик

    isElementPresent?(:xpath, "//img[@class='toggleChildProfiles'][@src='http://admin.abcp.ru/common.images/dtree/nolines_plus.gif']")
    $driver.find_element(:xpath, "//*[contains(text(),'#{nameProfile}')]/following-sibling::*/*/img[@title='Указать наценки по поставщикам']").click
    $driver.find_element(:xpath, "//*[contains(text(),'#{findD}')]/following-sibling::*/*/img[@alt='Редактировать']").click

    while x3<i
        x3=x3+1
        $driver.find_element(:link_text, 'Добавить наценку на бренд').click
        $driver.find_element(:xpath, "//td[@class='talignCenter brandName']/input[@brandname=-'#{x3}']").send_keys "#{arrBrand[x3-1]}"
        $driver.find_element(:xpath, "//input[@class='priceUp'][@brandname=-'#{x3}']").clear
        if priceUp
            $driver.find_element(:xpath, "//input[@class='priceUp'][@brandname=-'#{x3}']").send_keys priceUp
        else
            $driver.find_element(:xpath, "//input[@class='priceUp'][@brandname=-'#{x3}']").send_keys rand(-100..100).to_s
        end

    end
    $driver.find_element(:name, 'savePriceUpOnBrands').click
    $driver.find_element(:id, 'popup_msg_ok').click
end

def visibleElement? text,neesSee=1
    a = $driver.find_element(:xpath, "//*[contains(text(),'#{text}')]").displayed?

    if a && neesSee==1
        puts " Всё Норм! Отображается на странице текст: #{text} #{@conslwhite}"
    elsif a==false && neesSee==0
        puts " Всё Норм! НЕ видно этого элемента: #{text} #{@conslwhite}"
    else
        puts "#{@conslred} Видимость элемента не соответствует условию #{text} #{@conslwhite}"
        return false
    end
    rescue
        puts "#{@conslred}Вообще ошибка при попытке поиска отображения элемента/текста #{@conslwhite}"
        return false

end

def login4mc phone,pass ## куча костылей из-за кривой и непонятной регистрации на 4мс
    ### бляяяя , это уже не куча костылей , а просто трешь какой-то и всё из-за того, что при запуске автотестов с 25.08.2014 перестало логиниться по нормальному.
    ## буду надеяться, что в будущем станет более логичная авторизация, или хотя бы её просто изменять и автотесты опять заработают
    $driver.find_element(:id,'loginEnter').click
    if isElementPresentlite(:class,'clientNameWrapper')
        isElementPresent?(:class,'clientNameWrapper')
        isElementPresent?(:xpath, "//*[contains(text(),'Выход')]")
        $driver.get 'http://4mycar.ru/'
        $driver.find_element(:id,'loginEnter').click
    end
    $driver.find_element(:id,'inputPhone1').click
    $driver.find_element(:id,'inputPhone1').send_keys phone
    $driver.find_element(:id,'inputPassword').send_keys pass
    $driver.find_element(:xpath,"//*[contains(text(),'Далее')]").click
    isElementPresent?(:xpath,"//*[@value='Подтвердить']")
    ##asleep
    ##$driver.get 'http://4mycar.ru/'

    if isElementPresentlite(:id,'loginEnter')
        puts 'if'
    isElementPresent?(:id,'loginEnter')
    $driver.find_element(:xpath,"//button[@type='submit']").click
    isElementPresent?(:id,'loginEnter')
    $driver.find_element(:class,'logout').click
    $driver.find_element(:id,'inputPhone1').click
    $driver.find_element(:id,'inputPhone1').send_keys phone
        asleep
    $driver.find_element(:id,'inputPassword').click
    $driver.find_element(:id,'inputPassword').send_keys pass
    asleep
    $driver.find_element(:xpath,"//*[contains(text(),'Далее')]").click
    $driver.find_element(:xpath,"//*[contains(text(),'Сохранить')]").click
    $driver.get 'http://4mycar.ru/'
    isElementPresent?(:id,'loginEnter')
    end
end

def addReportToPage

    autArr = ['piletskiy', 'nodakola22', 'piletskiy.abcp.ru']
    choiceBrws
    authPUservice autArr[0], autArr[1], autArr[2], 1

    file = File.open(@namefile,"rb:UTF-8")
       @contents = file.read
    file.close
    x2x2 = @err.to_s
    puts "#{x2x2} -- Это кол-во ошибок, если оно не равно нулю, то не отображается сообщение |||| все тесты пройдены успешно"
    if @err == 0
        @contents = '|||| все тесты пройдены успешно

' + @contents
    end

    Clipboard.copy @contents

    $driver.find_element(:link_text,'Внешний вид и контент').click
    $driver.find_element(:link_text,'Страницы').click
    $driver.find_element(:name,'pageName').send_keys 'report'
    $driver.find_element(:xpath,"//*[@value='Найти']").click
    $driver.find_element(:xpath,"//*[contains(text(),'report')]/../following-sibling::td[2]/a/img").click
    $driver.find_element(:link_text,'Редактировать содержимое страницы.').click
    $driver.find_element(:xpath,"//img[@src='http://admin.abcp.ru/common.images/cp.icon/text-edit.png']").click
    element = $driver.find_element(:id,'infoBlockText_ifr')
    $driver.switch_to.frame element
                textArea = $driver.find_element(:xpath,"//body[@id='tinymce'][@onload=\"window.parent.tinymce.get('infoBlockText').fire('load');\"]")
    textArea.clear
    textArea.send_keys [:control, 'v']
    $driver.switch_to.default_content
    $driver.find_element(:xpath,"//*[*='Изменить']").click
    $driver.find_element(:xpath,"//*[*='Выделить все']").click
    $driver.find_element(:xpath,"//*[*='Размер']").click
    $driver.find_element(:xpath,"//*[*='10pt']").click
    ##$driver.find_element(:name,'saveInfoBlock').click
    $driver.find_element(:xpath,"//*[contains(text(),'Сохранить')]").click

    $driver.get 'http://cp.abcp.ru/?page=content&pages'
    $driver.find_element(:name,'pageName').send_keys 'report'
    $driver.find_element(:xpath,"//*[@value='Найти']").click
    $driver.find_element(:xpath,"//*[contains(text(),'report')]/../following-sibling::td[2]/a/img").click
    $driver.find_element(:link_text,'Редактировать содержимое страницы.').click
    $driver.find_element(:xpath,"//img[@src='http://admin.abcp.ru/common.images/cp.icon/file-htm.png']").click
    element = $driver.find_element(:id,'infoBlockText')
   ## element.clear

    file = File.open('css.txt', "rb:UTF-8")
    @contents = file.read

    file.close
    ## Такой вот забавный жИкверь, помогает выделить в уже существующем тексте необходимые строки и значения
    element.send_keys @contents
    $driver.find_element(:xpath,"//*[contains(text(),'Сохранить')]").click
    ##$driver.find_element(:name,'saveInfoBlock').click
asleep
    $driver.quit
end

def waitUntilLoadPrice autharr,nameFra=false,nameDistr=false
    begin

choiceBrws
authPUservice autharr[0], autharr[1], autharr[2], 1
@out_file.puts("\b \b Отчет . Проверям результат загрузки дистрибьюторов")
    if nameFra
        $driver.find_element(:link_text, "Клиенты").click
        $driver.find_element(:link_text, "Франчайзи").click
        hrefPUfranch =$driver.find_element(:xpath, "//*[contains(text(),#{nameFra})]/following-sibling::*/*/*[@title='Выполнить вход в панель управления: ']/parent::a").attribute('href')
        $driver.get hrefPUfranch
    end

    $driver.find_element(:link_text, 'Поставщики').click

    while isElementPresentlite(:xpath, "//*[contains(text(),'Идёт обновление прайс-листа...')]")
        $driver.find_element(:link_text, 'Поставщики').click
        asleep 10, 'Ещё не загрузился файл'
    end

    if nameDistr.size > 0
        nameDistr.each do |i|
        ii=i.match(/([A-z]{1,})/)
        puts ii
        asleep
        $driver.find_element(:xpath, "//table[*]/tbody/tr[*]/td/span[contains(text(),'#{i}')]/../following-sibling::td[9]/*/*/span[contains(text(),'результаты')]").click
        ddd = $driver.find_element(:xpath, "//table[*]/tbody/tr[*]/td/span[contains(text(),'#{i}')]/../following-sibling::td[9]/*/*/div/a").text
        if  ddd == 'Успешно'
            @out_file.puts("\b DISTR:#{ii} + в загрузке")


        else
            @err+=1
            @out_file.puts("ERR: При проверке загрузки дистрибьютора #{ii} есть ошибка!")
            $driver.find_element(:xpath, "//table[*]/tbody/tr[*]/td/span[contains(text(),'#{ii}')]/../following-sibling::td[9]/*/*/div/a").click
            if isElementPresentlite(:xpath, "//*[contains(text(),'Номер, описание ошибки:')]")
                @out_file.puts("\b DISTR:#{ii} ERR: в тексте загрузки прайса есть ОШИБКА")
            else
                @out_file.puts("\b DISTR:#{ii} Проверяем успешную загрузку файла. В Успешном результате нет текста с ошибкой")
            end
            $driver.find_element(:xpath,"//a[@title='Close']").click

        end

        end
        $driver.get 'http://root.abcp.ru/?page=messages_monitor'
        nameDistr.each do |i|
            puts i
            $driver.find_element(:name,'text').send_keys i
            $driver.find_element(:id,'mysubmit').click
            $driver.find_element(:link_text,'Отправлено').click
            $driver.switch_to.window $driver.window_handles.last
            $driver.find_element(:xpath, "//*[contains(text(),'Обработан')]")
            $driver.find_element(:xpath, "//*[contains(text(),'Результат обновления поставщика')]")
            $driver.find_element(:xpath, "//*[contains(text(),'EmailEmploynodatest@nodasoft.com')]")
            $driver.switch_to.window $driver.window_handles.first
            $driver.find_element(:name,'text').clear
            @out_file.puts("\b В руте проверено письмо о обновление дистрибьютора #{i} , которое отослано сотруднику")
        end
    end

    rescue
        @err+=1
        @out_file.puts("\b \b \b \b \b ERR Проверка поставщиков провалилась")

    end
    $driver.quit
end


def verifSendEmailOrder numOrder
$driver.find_element(:link_text,'Настройка').click
$driver.find_element(:link_text,'Управление почтой').click
sendmail =$driver.find_element(:xpath,"//*[contains(text(),'no-reply')]").text
$driver.get 'http://root.abcp.ru/?page=outbox'
$driver.find_element(:name,'idFrom').send_keys sendmail
$driver.find_element(:xpath,"//*[@src='http://admin.abcp.ru/common.images/filter.png']").click
findTextInPage ["Заказ номер #{numOrder}","Ваш заказ номер #{numOrder}"],1
end

def checkedPriceIn nameChecked

    $driver.find_element(:link_text,'Настройка').click
    $driver.find_element(:link_text,'Настройка столбцов в результатах поиска').click
    if isElementPresentlite(:xpath,"//*[@name='#{nameChecked}'][@checked='checked']")
    else
        $driver.find_element(:xpath,"//*[@name='#{nameChecked}']").click
    end
end


def parserCurrency
    begin
    printing_page = Nokogiri::HTML(open("http://kovalut.ru/index.php?kod=6121"))
    best_price = printing_page.css('.wi')[0] # This is a overly simple finder. Nokogiri can do xpath searches too.
    best_price=best_price.text
    arrCURS = best_price.scan(/(\d{1,4}.\d{1,4})/)
    arrNAME = ['Покупка доллара:','Продажа доллара:','Покупка евро:','Продажа евро:']
    x=0
    arrCURS.each do |e|
        @out_file.puts(" \b #{arrNAME[x]} #{e} \b \b \b \b ")
        x=x+1
    end
    rescue
    end
end

def parserPogodaTGKMSK
    begin
        x=0
        arrWords = []
        printing_page = Nokogiri::HTML(open("http://rp5.ru/%D0%9F%D0%BE%D0%B3%D0%BE%D0%B4%D0%B0_%D0%B2_%D0%A2%D0%B0%D0%B3%D0%B0%D0%BD%D1%80%D0%BE%D0%B3%D0%B5"))
        best_price = printing_page.css('span b')[0]  # This is a overly simple finder. Nokogiri can do xpath searches too.
        best_price = best_price.text
        find_words=best_price.scan(/[0-9a-zа-я]{5,66}/i)
        best_price=best_price.match(/Завтра\s*плюс\s*.{6}/)
        @out_file.puts(" \b #{best_price}  \b \b \b \b ")
        find_words.each do |e|
            if x == 1
                @x2 = e + ' ' + @x2.to_s
            end
            if e == 'Завтра'
                x=1
            end
        end
        @out_file.puts(" \b Теги погоды на завтра в Таганроге: #{@x2} \b \b \b \b ")
    rescue
    end
end


class PageRoute
    def goToRouteList distrName,nameRoute=false
        $driver.find_element(:xpath, "//table[*]/tbody/tr[*]/td/span[contains(text(),'#{distrName}')]/../following-sibling::td[2]").click
        if nameRoute
        else
            $driver.find_element(:xpath,"//td/a[@title='Редактировать маршрут']").click
        end
    end
    def changeRoute arrToChange
        y=0
        x = arrToChange.size
        while y < x
            $driver.find_element(:name,arrToChange.keys[y]).clear
            $driver.find_element(:name,arrToChange.keys[y]).send_keys arrToChange.values[y]
            y+=1
        end
        $driver.find_element(:xpath,"//*[@value='Сохранить изменения']").click
    end

end

######################### Alien
def show_wait_spinner(fpsx=10)
    chars = %w[| / - \\]
    delay = 1.0/fpsx
    iter = 0
    spinner = Thread.new do
        while iter do # Keep spinning until told otherwise
            print chars[(iter+=1) % chars.length]
            sleep delay
            print "\b"
        end
    end
    yield.tap { # After yielding to the block, save the return value
        iter = false # Tell the thread to exit, cleaning up after itself…
        spinner.join # …and wait for it to do so.
    } # Use the block's return value as the method's
end

def asleep x=3, des=false
    if des
        puts des
    end
    show_wait_spinner {
        sleep x
    }
end






