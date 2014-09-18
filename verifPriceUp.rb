#!/bin/env ruby
# encoding: utf-8

#Добавление профиля
require '/opt/projects/autotest/Ruby/musthave'


def editPriceUpProf nameProfile,priceUp,priceUpDistrOrBrandDistr=false,brandName=false,cenaMinMax=false
    $driver.get @hrefPU
    $driver.find_element(:link_text,'Клиенты').click
    $driver.find_element(:link_text,'Профили').click
    if priceUpDistrOrBrandDistr
        ## нужно придумать фикс уже редактированного поставщика
        $driver.find_element(:xpath, "//*[contains(text(),'#{nameProfile}')]/following-sibling::*/*/img[@title='Указать наценки по поставщикам']|//*[contains(text(),'#{nameProfile}')]/following-sibling::*/*/img[@title='Редактировать наценки по поставщикам']").click
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
temp = temp.match(/(\d*,\d{2})/).to_s.sub!(',','.').to_f.round(2)
goodPrice = goodPrice.to_f.round(2)
puts "#{goodPrice} -- вот эту цену мы ждем"
    if temp == goodPrice
      ##  puts 'Проверка пройдена. Цена у клиента соответствует ожидаемой'
    else
        @err+=1
        puts 'ERR: цена у клиента не соответствует ожидаемой!!!!'
    end
end

#### Исходим из того, что у реселлера на момент начала теста есть только один подключенный поставщик! Так как остальный удалены/отключены автотестами по добавлению прайса

def verifPriceUp autharr,nameFra=false,pnum='OC90'

    ## для этого автотеста необходимо наличие хоть какого-то товара в результатах поиска, именно поэтому мы будем распологать его после добавления прайсов в тестовом наборе
    puts "#{@conslgreen}Начинаем АВТОТЕСТ -- проверка наценок в профиле клиента#{@conslwhite}"
    @out_file.puts("\n Отчет прохождения теста по проверке наценок в профиле клиента")
    step = 0
    allstep = 58
    @pnum = pnum
    begin
        choiceBrws 1
        authPUservice autharr[0], autharr[1], autharr[2], 1

    if nameFra
        $driver.find_element(:link_text, 'Клиенты').click
        $driver.find_element(:link_text, 'Франчайзи').click
        @hrefPU =$driver.find_element(:xpath, "//*[contains(text(),'#{nameFra}')]/following-sibling::*/*/*[@title='Выполнить вход в панель управления: ']/parent::a").attribute("href")
        $driver.get @hrefPU
    end

    @out_file.puts("Шаг #{step+=1} из #{allstep} Выставляем отображение цены закупки для менеджеров")
        checkedPriceIn 'priceBuyEnable'
        checkedPriceIn 'distributorEnable'

    @out_file.puts("Шаг #{step+=1} из #{allstep} Получаем сслыку для входа на сайт менеджером (администратором)")
        $driver.find_element(:link_text,'Персонал').click
        hrefSiteAdmin = $driver.find_element(:xpath, "//*[contains(text(),'admin')]/following-sibling::td[12]/a").attribute("href")
        clientName = randomTxt(15)
    @out_file.puts("Шаг #{step+=1} из #{allstep} Создаем нового клиента. Получаем ссылку для входа на сайт. Новый клиент должен создавать по дефолту без профиля. Имя клиента #{clientName}")
        $driver.find_element(:link_text, "Клиенты").click
        $driver.find_element(:link_text, "Добавить клиента").click

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

    @out_file.puts("Шаг #{step+=1} из #{allstep} Переходим на сайт клиентом и видим цену продажи детали #{@pnum} равную закупке, так как не выставлен профиль")
        verifPriceClient hrefSiteClient,description,priceInFloat

        nameProfile = randomTxt(7)
    @out_file.puts("Шаг #{step+=1} из #{allstep} В ПУ создаем профиль без наценки, устанавливаем клиенту. Название профиля #{nameProfile}")
        $driver.get @hrefPU
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

        defProfPrice=-50
    @out_file.puts("Шаг #{step+=1} из #{allstep} Меняем для профиля наценку, ставим #{defProfPrice}")
        editPriceUpProf nameProfile,defProfPrice
    @out_file.puts("Шаг #{step+=1} из #{allstep} На сайте цена снизилась в два раза")
        verifPriceClient hrefSiteClient,description,priceInFloat/2

        brandPriceUp = -22
    @out_file.puts("Шаг #{step+=1} из #{allstep} Устанавливаем наценку на бренд в профиле #{brandPriceUp}")
        editPriceUpProf nameProfile,brandPriceUp, distrName,['Knecht']
    @out_file.puts("Шаг #{step+=1} из #{allstep} На сайте цена уменьшилась на 22 процента от закупочной")
        verifPriceClient hrefSiteClient,description,priceInFloat*(1+brandPriceUp/100.0)

    @out_file.puts("Шаг #{step+=1} из #{allstep} Добавляем для профиля наценку в зависимости от цены: диапазон цен 0-9999, наценка -9")
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

        verifPriceClient hrefSiteClient,description,priceInFloat*(1+brandPriceUp/100.0)

    @out_file.puts("Шаг #{step+=1} из #{allstep} Добавляем наценку от цены товара, но товар в поиске не попадает в диапазон наценки")
        editPriceUpProf nameProfile,'-9',false,false,['7777','9999']
    @out_file.puts("Шаг #{step+=1} из #{allstep} На сайте цена как от наценки на бренд")
        fix_step = step
        priceInFloat2 = priceInFloat*(1+brandPriceUp/100.0)
        verifPriceClient hrefSiteClient,description,priceInFloat*(1+brandPriceUp/100.0)

        ### Начинаем наценки на маршрут

    @out_file.puts("Шаг #{step+=1} из #{allstep} в маршруте меняем параметр P2, устанавливаем 100")
        $driver.get @hrefPU
        $driver.find_element(:link_text,'Поставщики').click
        description_new = randomTxt 40
        arrRoute = {'deadline_new' => '23', 'p2_new' => '100','description_new'=>description_new}
        route = PageRoute.new
        route.goToRouteList distrName
        route.changeRoute arrRoute

    @out_file.puts("Шаг #{step+=1} из #{allstep} На сайте цена увеличилась на 100 процентов, от прошлой цены проверки")
        verifPriceClient hrefSiteClient,description,priceInFloat2*2

    @out_file.puts("Шаг #{step+=1} из #{allstep} в маршруте меняем параметр P2, устанавливаем -54")
        $driver.get @hrefPU
        $driver.find_element(:link_text,'Поставщики').click
        arrRoute = {'deadline_new' => '23', 'p2_new' => '-54'}
        route.goToRouteList distrName
        route.changeRoute arrRoute
    @out_file.puts("Шаг #{step+=1} из #{allstep} На сайте цена уменьшилась на 54 процента от цены проверки из шага #{fix_step}")
        verifPriceClient hrefSiteClient,description,priceInFloat2*0.46

    @out_file.puts("Шаг #{step+=1} из #{allstep} в маршруте меняем параметр P1 устанавливаем 333, параметр Р2 обнуляем")
        $driver.get @hrefPU
        $driver.find_element(:link_text,'Поставщики').click
        arrRoute = {'deadline_new' => '23', 'p2_new' => '0','p1_new'=>'333'}
        route.goToRouteList distrName
        route.changeRoute arrRoute
    @out_file.puts("Шаг #{step+=1} из #{allstep} На сайте цена увеличилась на 333% относительно цены в шаге #{fix_step}")
        verifPriceClient hrefSiteClient,description,priceInFloat2*4.33

    @out_file.puts("Шаг #{step+=1} из #{allstep} в маршруте меняем параметр P1 устанавливаем -55")
        $driver.get @hrefPU
        $driver.find_element(:link_text,'Поставщики').click
        arrRoute = {'deadline_new' => '23','p1_new'=>'-55'}
        route.goToRouteList distrName
        route.changeRoute arrRoute
    @out_file.puts("Шаг #{step+=1} из #{allstep} На сайте цена уменьшилась на 55% относительно цены в шаге #{fix_step}")
        verifPriceClient hrefSiteClient,description,priceInFloat2*0.45

    @out_file.puts("Шаг #{step+=1} из #{allstep} в маршруте меняем параметр P1 устанавливаем -55")
        $driver.get @hrefPU
        $driver.find_element(:link_text,'Поставщики').click
        arrRoute = {'deadline_new' => '23','p1_new'=>'-55'}
        route.goToRouteList distrName
        route.changeRoute arrRoute
    @out_file.puts("Шаг #{step+=1} из #{allstep} На сайте цена уменьшилась на 55% относительно цены в шаге #{fix_step}")
        verifPriceClient hrefSiteClient,description,priceInFloat2*0.45

        ###### С1 , формула:
        ### priceOut = priceIn * ( 1 + 'Добавочная наценка' / 100)*(1 + priceUp*(1 + C1/100)/100)
        ### то есть, коэфф Ц1 применяется с прайсАП, то есть умножает именно прайсАП на себя самого
        ### соответственно если добавить
        ###C1% - количество процентов, которые будут прибавлены к наценке клиента. Если нужно уменьшить наценку для клиента, указывайте
        # отрицательное значение в этом коэффициенте.
        # Пример: наценка для клиента Петя = 30%. Если установить C1=-33%, то наценка клиента будет уменьшена на треть и станет равной 20%
        ######

    @out_file.puts("Шаг #{step+=1} из #{allstep} в маршруте меняем параметр C1 устанавливаем 100, остальные параметры обнуляем")
        $driver.get @hrefPU
        $driver.find_element(:link_text,'Поставщики').click
        arrRoute = {'deadline_new' => '23','p1_new'=>'0','c1_new'=>'100'}
        route.goToRouteList distrName
        route.changeRoute arrRoute
    @out_file.puts("Шаг #{step+=1} из #{allstep} На сайте выводится цена с наценкой на бренд (-22 процента) умноженной на 2")

        verifPriceClient hrefSiteClient,description,priceInFloat-(priceInFloat*0.22*2)

    @out_file.puts("Шаг #{step+=1} из #{allstep} в маршруте меняем параметр C1 устанавливаем 100, остальные параметры обнуляем")
        $driver.get @hrefPU
        $driver.find_element(:link_text,'Поставщики').click
        arrRoute = {'deadline_new' => '23','p1_new'=>'0','c1_new'=>'-100'}
        route.goToRouteList distrName
        route.changeRoute arrRoute
    @out_file.puts("Шаг #{step+=1} из #{allstep} На сайте выводится цена как бы без наценки, из-за того что -100 в формуле прайсАут умножает прайсАП на ноль")
        verifPriceClient hrefSiteClient,description,priceInFloat


    @out_file.puts("Шаг #{step+=1} из #{allstep} в маршруте меняем параметр C1 устанавливаем -155, остальные параметры обнуляем")
        $driver.get @hrefPU
        $driver.find_element(:link_text,'Поставщики').click
        c1=-155
        arrRoute = {'deadline_new' => '23','p1_new'=>'0','c1_new'=>c1.to_s}
        route.goToRouteList distrName
        route.changeRoute arrRoute
    @out_file.puts("Шаг #{step+=1} из #{allstep} На сайте выводится цена рассчитанная по формуле: (Цена_закупки+(Цена_закупки*(1+(c1/100.0))*(Наценка_На_Бренд/100.0)))")
        verifPriceClient hrefSiteClient,description,(priceInFloat+(priceInFloat*(1+(c1/100.0))*(brandPriceUp/100.0)))


       ## Приоритетная наценка. данный вид наценки действует только если он больше наценки на поставщика у покупателя. Но даже если
        # #     наценка на поставщика не установлена, то это считается как 0, соответственно если задана приоритетная наценка, то наценка профиля не работает.
        # #     при этом наценка не бред вполне влияет на конечную стоимость, вне зависимости от того больше она приоритетной наценки или меньше
    @out_file.puts("Шаг #{step+=1} из #{allstep} Выставляем приоритетную наценку. Но помним, что есть наценка на бренд!")
        $driver.get @hrefPU
        $driver.find_element(:link_text,'Поставщики').click
        primary_priceup_to_contractor_new = rand(50..99)
        arrRoute = {'deadline_new' => '23','p1_new'=>'0','c1_new'=>'0','primary_priceup_to_contractor_new'=>primary_priceup_to_contractor_new.to_s}
        route.goToRouteList distrName
        route.changeRoute arrRoute
    @out_file.puts("Шаг #{step+=1} из #{allstep} Мы видим наценку от бренда, так как она установлена и имеет более высший приоритет, чем приоритетная наценка")
        verifPriceClient hrefSiteClient,description,priceInFloat*(1+brandPriceUp/100.0)

    @out_file.puts("Шаг #{step+=1} из #{allstep} Удаляем наценку на бренд, более ничего не меняем")
        $driver.get @hrefPU
        $driver.find_element(:link_text,'Клиенты').click
        $driver.find_element(:link_text,'Профили').click
        isElementPresent?(:xpath, "//img[@class='toggleChildProfiles'][@src='http://admin.abcp.ru/common.images/dtree/nolines_plus.gif']")
        $driver.find_element(:xpath, "//*[contains(text(),'#{nameProfile}')]/following-sibling::*/*/img[@title='Указать наценки по поставщикам']").click
        $driver.find_element(:xpath, "//*[contains(text(),'#{distrName}')]/following-sibling::*/*/img[@alt='Редактировать']").click
        $driver.find_element(:xpath, "//*[contains(text(),'Knecht:')]/following-sibling::*/a[@title='Удалить наценку на бренд']").click
        $driver.find_element(:name, 'savePriceUpOnBrands').click
        $driver.find_element(:id, 'popup_msg_ok').click
    @out_file.puts("Шаг #{step+=1} из #{allstep} Видим теперь приоритетную наценку, так как она больше наценки на поставщика, которая равна нулю. Приоритетная наценка равна #{primary_priceup_to_contractor_new}")
        verifPriceClient hrefSiteClient,description,priceInFloat*(1+primary_priceup_to_contractor_new/100.0)

    @out_file.puts("Шаг #{step+=1} из #{allstep} Добавляем наценку на поставщика в профиле, чтобы она была больше приоритетной")
        temp = rand(100..200)
        editPriceUpProf nameProfile,temp,distrName
    @out_file.puts("Шаг #{step+=1} из #{allstep} На сайте цена отображается с наценкой от поставщика. Приоритетная наценка игнорируется")
        verifPriceClient hrefSiteClient,description,priceInFloat*(1+temp/100.0)

    @out_file.puts("Шаг #{step+=1} из #{allstep} Добавляем наценку на поставщика в профиле, чтобы она стала меньше приоритетной")
        temp = rand(1..49)
        editPriceUpProf nameProfile,temp,distrName
    @out_file.puts("Шаг #{step+=1} из #{allstep} На сайте цена отображается с приоритетной наценкой")
        verifPriceClient hrefSiteClient,description,priceInFloat*(1+primary_priceup_to_contractor_new/100.0)

    @out_file.puts("Шаг #{step+=1} из #{allstep} Удаляем наценку на поставщика в профиле")
        temp = ' '
        editPriceUpProf nameProfile,temp,distrName

        # Добавочная нацека -- просто увеличивает цену закупки. По формуле priceOut = priceIn * ( 1 + 'Добавочная наценка' / 100)*(1 + priceUp*(1 + C1/100)/100) получаем,
        # что цена для клиента так же просто умножается на Добавочную наценку
        # #
    @out_file.puts("Шаг #{step+=1} из #{allstep} Устанавливаем Добавночную наценку. При этом не обнуляем Приоритетную наценку")
        $driver.get @hrefPU
        $driver.find_element(:link_text,'Поставщики').click
        price_up_added_new = rand(-99..99)
        arrRoute = {'price_up_added_new'=>price_up_added_new.to_s}
        route.goToRouteList distrName
        route.changeRoute arrRoute
    @out_file.puts("Шаг #{step+=1} из #{allstep} Цена для клиента изменилась относительно прошлого шага на #{price_up_added_new} процентов")
        verifPriceClient hrefSiteClient,description,priceInFloat*(1+price_up_added_new/100.0)*(1+primary_priceup_to_contractor_new/100.0)


    @out_file.puts("Шаг #{step+=1} из #{allstep} Устанавливаем Добавночную наценку. При этом ОБНУЛЯЕМ Приоритетную наценку")
        $driver.get @hrefPU
        $driver.find_element(:link_text,'Поставщики').click
        price_up_added_new = rand(-99..99)
        arrRoute = {'primary_priceup_to_contractor_new'=>'0','price_up_added_new'=>price_up_added_new.to_s}
        route.goToRouteList distrName
        route.changeRoute arrRoute
    @out_file.puts("Шаг #{step+=1} из #{allstep} Цена для клиента изменилась. Теперь она равняется цене закупки умноженной на #{price_up_added_new} процентов и умноженной на наценку из профиля: #{priceInFloat*(1+price_up_added_new/100.0)*(1+defProfPrice/100.0)}")
        verifPriceClient hrefSiteClient,description,priceInFloat*(1+price_up_added_new/100.0)*(1+defProfPrice/100.0)

    @out_file.puts("Шаг #{step+=1} из #{allstep} Меняем для профиля наценку, ставим ноль")
        editPriceUpProf nameProfile,0
    @out_file.puts("Шаг #{step+=1} из #{allstep} Цена для клиента изменилась. Теперь она равняется цене закупки умноженной на #{price_up_added_new} процентов: #{priceInFloat*(1+price_up_added_new/100.0)}")
        verifPriceClient hrefSiteClient,description,priceInFloat*(1+price_up_added_new/100.0)


        # Минимальные и максимальные ограничения наценки . PriceUp PriceMin, они режут уже полученную наценку, соответственно они не влияют на формирование закупочной цены
        # #

    @out_file.puts("Шаг #{step+=1} из #{allstep} Выставляем минимальную наценку = 100. И обнуляем другие параметры ")
        $driver.get @hrefPU
        $driver.find_element(:link_text,'Поставщики').click
        arrRoute = {'price_up_added_new'=>'0','price_up_min_new'=>'100'}
        route.goToRouteList distrName
        route.changeRoute arrRoute
    @out_file.puts("Шаг #{step+=1} из #{allstep} Цена равняется двум закупочным")
        verifPriceClient hrefSiteClient,description,priceInFloat*2

        defProfPrice=rand(99..100)
    @out_file.puts("Шаг #{step+=1} из #{allstep} Меняем для профиля наценку, ставим #{defProfPrice}")
        editPriceUpProf nameProfile,defProfPrice
        @out_file.puts("Шаг #{step+=1} из #{allstep} Цена как в прошлом шаге")
        verifPriceClient hrefSiteClient,description,priceInFloat*2

        defProfPrice=rand(200..300)
    @out_file.puts("Шаг #{step+=1} из #{allstep} Меняем для профиля наценку, ставим #{defProfPrice}")
        editPriceUpProf nameProfile,defProfPrice
    @out_file.puts("Шаг #{step+=1} из #{allstep} Цена изменилась. Теперь она формируется с наценкой профиля #{defProfPrice}")
        verifPriceClient hrefSiteClient,description,priceInFloat*(1+defProfPrice/100.0)


    @out_file.puts("Шаг #{step+=1} из #{allstep} Выставляем максимальную наценку = 150 ")
        $driver.get @hrefPU
        $driver.find_element(:link_text,'Поставщики').click
        arrRoute = {'price_up_max_new'=>'150'}
        route.goToRouteList distrName
        route.changeRoute arrRoute
    @out_file.puts("Шаг #{step+=1} из #{allstep} Наценка ограничена максимальной наценкой в маршруте. Итоговая цена: #{priceInFloat*(1+150/100.0)}")
        verifPriceClient hrefSiteClient,description,priceInFloat*(1+150/100.0)

    rescue
        @err+=1
        puts "#{@conslred}ERR: Тест не пройден, всё плохо #{@conslwhite}"
        @out_file.puts('ERR: Тест прерван')
    end
    $driver.quit

end









