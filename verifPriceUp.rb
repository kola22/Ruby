#!/bin/env ruby
# encoding: utf-8

#Добавление профиля
require '/opt/projects/autotest/Ruby/musthave'


def editPriceUpProf nameProfile,priceUp,priceUpDistrOrBrandDistr=false,brandName=false,cenaMinMax=false
    $driver.get @hrefPU
    $driver.find_element(:link_text,'Клиенты').click
    $driver.find_element(:link_text,'Профили').click
    if priceUpDistrOrBrandDistr
        $driver.find_element(:xpath, "//*[contains(text(),'#{nameProfile}')]/following-sibling::*/*/img[@title='Указать наценки по поставщикам']").click
        if brandName
            AddPriceUpBrand brandName,nameProfile,priceUpDistrOrBrandDistr[0],priceUp
        else
            distrPriceUp = $driver.find_element(:xpath, "//*[contains(text(),'#{priceUpDistrOrBrandDistr}')]/following-sibling::*/*[@name='priceUpOnDistributors']")
            distrPriceUp.click
            distrPriceUp.clear
            distrPriceUp.send_keys priceUp
            $driver.find_element(:xpath, '//input[@value="Сохранить"]').click
            isElementPresent?(:id, 'popup_msg_ok')
        end
    elsif cenaMinMax
        $driver.find_element(:xpath, "//*[contains(text(),'#{nameProfile}')]/following-sibling::*/*/img[@title='Редактировать']").click
        $driver.find_element(:id,'addPriceUp').click
        priceMin = $driver.find_element(:xpath,"//tr[@class='pricesUpHeader']/following-sibling::tr[@class='pricesUp']/*/input[@name='priceMin']")
        priceMin.clear
        priceMin.send_keys cenaMinMax[0]
        priceMax = $driver.find_element(:xpath,"//tr[@class='pricesUpHeader']/following-sibling::tr[@class='pricesUp']/*/input[@name='priceMax']")
        priceMax.clear
        priceMax.send_keys cenaMinMax[1]
        up=$driver.find_element(:xpath,"//tr[@class='pricesUpHeader']/following-sibling::tr[@class='pricesUp']/*/input[@name='priceUp']")
        up.clear
        up.send_keys priceUp
        $driver.find_element(:xpath, '//td[@class="ralignRight"]/input[@value="Сохранить"]').click
        isElementPresent?(:id, 'popup_msg_ok')
    else
        $driver.find_element(:xpath, "//*[contains(text(),'#{nameProfile}')]/following-sibling::*/*/img[@title='Редактировать']").click
        $driver.find_element(:xpath,"//input[@name='priceUp'][@maxlength='5']").clear
        $driver.find_element(:xpath,"//input[@name='priceUp'][@maxlength='5']").send_keys priceUp
        $driver.find_element(:xpath, '//td[@class="ralignRight"]/input[@value="Сохранить"]').click
        isElementPresent?(:id, 'popup_msg_ok')
    end
end

def verifPriceClient hrefSiteClient,description,goodPrice
$driver.get hrefSiteClient
asleep
$driver.find_element(:id, "pcode").send_keys "#{@pnum}"
$driver.find_element(:id, "pcode").submit
isElementPresent?(:xpath, "//*[contains(text(),'Цены и аналоги')]")
temp = $driver.find_element(:xpath,"//*[@class='resultDescription  '][contains(text(),'#{description}')]/following-sibling::*[@class='resultPrice ']").text
puts temp
temp = temp.match(/(\d*,\d{2})/).to_s.sub!(',','.').to_f.round(2)
puts temp
goodPrice = goodPrice.to_f.round(2)
puts "#{goodPrice} -- вот эту цену мы ждем"
if temp == goodPrice
    puts 'Проверка пройдена. Цена у клиента соответствует ожидаемой'
else
    puts 'ERR: цена у клиента не соответствует ожидаемой!!!!'
end
end

#### Исходим из того, что у реселлера на момент начала теста есть только один подключенный поставщик! Так как остальный удалены/отключены автотестами по добавлению прайса
def verifPriceUp autharr,nameFra=false
    ## для этого автотеста необходимо наличие хоть какого-то товара в результатах поиска, именно поэтому мы будем распологать его после добавления прайсов в тестовом наборе
    puts "#{@conslgreen}Начинаем АВТОТЕСТ -- проверка наценок в профиле клиента#{@conslwhite}"
    @out_file.puts("\n Отчет прохождения теста по проверке наценок в профиле клиента")
    step = 0
    allstep = 11
    @pnum = 'OC90'
    begin
        choiceBrws 1
        authPUservice autharr[0], autharr[1], autharr[2], 1

    if nameFra
        $driver.find_element(:link_text, 'Клиенты').click
        $driver.find_element(:link_text, 'Франчайзи').click
        hrefPUfranch =$driver.find_element(:xpath, "//*[contains(text(),'#{nameFra}')]/following-sibling::*/*/*[@title='Выполнить вход в панель управления: ']/parent::a").attribute("href")
        $driver.get hrefPUfranch
    end

    @out_file.puts("Шаг #{step+=1} из #{allstep} Выставляем отображение цены закупки для менеджеров")
        checkedPriceIn 'priceBuyEnable'
        checkedPriceIn 'distributorEnable'

    @out_file.puts("Шаг #{step+=1} из #{allstep} Получаем сслыку для входа на сайт менеджером (администратором)")
        $driver.find_element(:link_text,'Персонал').click
        hrefSiteAdmin = $driver.find_element(:xpath, "//*[contains(text(),'admin')]/following-sibling::td[12]/a").attribute("href")

    @out_file.puts("Шаг #{step+=1} из #{allstep} Создаем нового клиента. Получаем ссылку для входа на сайт. Новый клиент должен создавать по дефолту без профиля")
        $driver.find_element(:link_text, "Клиенты").click
        $driver.find_element(:link_text, "Добавить клиента").click
        clientName = randomTxt(15)
        $driver.find_element(:id, "newCustomerName").send_keys "#{clientName}"
        $driver.find_element(:id, "newCustomerEmail").send_keys "#{clientName}nodatest@nodasoft.com"
        $driver.find_element(:xpath, "//span[contains(text(),'Создать')]").click
        isElementPresent?(:xpath, "//span[contains(text(),'Создать')]")
        hrefSiteClient = $driver.find_element(:link_text, "Вход на сайт от имени клиента: \"#{clientName}\"").attribute("href")

    @out_file.puts("Шаг #{step+=1} из #{allstep} Переходим на сайт менеджером, ищем деталь #{@pnum} и получаем её закупочную цену,бренд и постащика")
        $driver.get hrefSiteAdmin
        $driver.find_element(:id, "pcode").send_keys "#{@pnum}"
        $driver.find_element(:id, "pcode").submit
        isElementPresent?(:xpath, "//*[contains(text(),'Цены и аналоги')]")
        distrName =  $driver.find_element(:class, "resultSupplier").text
        brand = $driver.find_element(:class,'brandInfoLink').text
        priceIn = $driver.find_element(:class,'resultPurchasesPrice').text ## тут мы получаем запись вида : 33,00 руб , надо бы перевести
        priceInFloat = priceIn.match(/(\d*,\d{2})/).to_s.sub!(',','.').to_f.round(2)
        description = $driver.find_element(:class,'resultDescription  ').text
        description = description.match(/(?<=\W)\s.*/)
        puts distrName,priceInFloat,brand,description

    @out_file.puts("Шаг #{step+=1} из #{allstep} Переходим на сайт клиентом и видим цену продажи детали OC90 равную закупке, так как не выставлен профиль")
        verifPriceClient hrefSiteClient,description,priceInFloat

    @out_file.puts("Шаг #{step+=1} из #{allstep} В ПУ создаем профиль без наценки, устанавливаем клиенту")
        $driver.get @hrefPU
        nameProfile = randomTxt(7)
        addProf nameProfile,0,0
        $driver.find_element(:link_text, "Клиенты").click
        $driver.find_element(:name,'filterCustomersBySearchString').send_keys clientName
        $driver.find_element(:xpath, "//*[@value='Найти']").click
        asleep
        $driver.find_element(:xpath, "//*[@title='Редактировать информацию о клиенте']").click
        $driver.find_element(:class, 'jq-selectbox__select-text').click
        $driver.find_element(:xpath, "//*[contains(text(),'#{nameProfile}')]").click
        asleep
        $driver.find_element(:xpath, "//*[@value='Сохранить изменения']").click
        isElementPresent?(:id,'popup_msg_ok')

    @out_file.puts("Шаг #{step+=1} из #{allstep} На сайте цена не поменялась")
        verifPriceClient hrefSiteClient,description,priceInFloat


    @out_file.puts("Шаг #{step+=1} из #{allstep} Меняем для профиля наценку , ставим 100")
        editPriceUpProf nameProfile,'100'
    @out_file.puts("Шаг #{step+=1} из #{allstep} На сайте цена выросла в два раза")
        verifPriceClient hrefSiteClient,description,priceInFloat*2

    @out_file.puts("Шаг #{step+=1} из #{allstep} Меняем для профиля наценку, ставим -50")
        editPriceUpProf nameProfile,'-50'
    @out_file.puts("Шаг #{step+=1} из #{allstep} На сайте цена снизилась в два раза")
        verifPriceClient hrefSiteClient,description,priceInFloat/2

    @out_file.puts("Шаг #{step+=1} из #{allstep} Устанавливаем наценку на бренд в профиле -22%")
        editPriceUpProf nameProfile,'-22', distrName,['Knecht']
    @out_file.puts("Шаг #{step+=1} из #{allstep} На сайте цена уменьшилась на 22 процента от закупочной")
        verifPriceClient hrefSiteClient,description,priceInFloat-priceInFloat*0.22

    @out_file.puts("Шаг #{step+=1} из #{allstep} Меняем для профиля наценку в зависимости от цены: диапазон цен 0-9999, наценка -9")
        editPriceUpProf nameProfile,'-9',false,false,['0','9999']
    @out_file.puts("Шаг #{step+=1} из #{allstep} На сайте цена уменьшилась на 9% от закупочной")
        verifPriceClient hrefSiteClient,description,priceInFloat*0.91

    @out_file.puts("Шаг #{step+=1} из #{allstep} Удаляем наценку от цены товара")
        $driver.get @hrefPU
        $driver.find_element(:link_text, "Клиенты").click
        $driver.find_element(:link_text,'Профили').click
        $driver.find_element(:xpath, "//*[contains(text(),'#{nameProfile}')]/following-sibling::*/*/img[@title='Редактировать']").click
        $driver.find_element(:xpath,"//tr[@class='pricesUpHeader']/following-sibling::tr[@class='pricesUp']/*/a[@class='deletePriceUp']").click
        $driver.find_element(:xpath, '//td[@class="ralignRight"]/input[@value="Сохранить"]').click
        isElementPresent?(:id, 'popup_msg_ok')
        @out_file.puts("Шаг #{step+=1} из #{allstep} На сайте цена как от наценки на бренд")
        verifPriceClient hrefSiteClient,description,priceInFloat-priceInFloat*0.22



        ### Начинаем наценки на маршрут
    @out_file.puts("Шаг #{step+=1} из #{allstep} меняем цену закупки товара")
        $driver.get @hrefPU
        $driver.find_element(:link_text,'Поставщики').click
        $driver.find_element(:xpath, "//table[*]/tbody/tr[*]/td/span[contains(text(),'#{distrName}')]/../following-sibling::td[2]").click
        $driver.find_element(:xpath,"//img[@alt='Редактировать маршрут']").click






        asleep 333
    rescue
        @err+=1
        puts "#{@conslred}ERR: Тест не пройден, всё плохо #{@conslwhite}"
        @out_file.puts('ERR: Тест прерван')
    end
    $driver.quit

end









