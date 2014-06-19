#!/bin/env ruby
# encoding: utf-8

require 'selenium-webdriver'

arrlog = ['kola22@mail.ru', 'dolgopolov-kb@mail.ru', 'bifitor@yandex.ru']
arrpass = ['kola22', 'kot2658511', 'bytnpfrfp']

driver = Selenium::WebDriver.for :chrome
wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds

def poniatno(name)

    btnHelp = driver.find_element :class => 'tooltipBtn'
    if btnHelp.text == name
        btnHelp.click
        puts btnHelp.text
    end
end

while i < 3

    driver.get "http://4mycar.ru"

    poniatno(name);


    sleep 3
    element = driver.find_element :id => 'loginEnter'
    element.click
    sleep 3
    login = driver.find_element :id => 'login'
    login.send_keys arrlog[i]
    pass = driver.find_element :id => 'pass'
    pass.send_keys arrpass[i]

    element = driver.find_element :class => 'authBottom'
    element.submit

    puts "1"


    element = driver.find_element :name => "pcode"
    element.send_keys "oc90"
    element.submit

    if arrlog[i] == 'kola22@mail.ru'<?p
        hp
        require_once Config::ABCP_COMMON_CODE_PATH. 'check_debt.php';
        ?>


        <style type="text/css">
        .allText {
            display : none;
            margin : 30 px 0 0;
        }
        .link-slide {
            cursor : pointer;
            border-bottom : 1 px dashed #38B0E3;
            color : #38B0E3;
        }
        </style>

<script>
    $(function() {
        $('.text-body .link-slide').click(function(){
            $(this).closest('.text-body').find('.allText').slideToggle('normal');
        });
// $ (".link-slide").click(function() {
            //
            // $(this).parent().next().slideToggle("normal");
            //
            // });
        });
        </script>




<div class="text-body">
    <div class="text-header">
        <span class="link-slide" style="font-size: 16px;">  ПОДРОБНО  </s pan>
        </div>
    <div class="allText">
        <div>
            <strong>abcpabcpabcpabcpabcpabcpabcpa  bcpabcpabc pabcpabcpabcpabcpabcpabcpabcp</s trong>
        </div>
    </ div>
        </div>























<div class="wrapper">
    <div class="head">
        <div class="logo">
            <a href="/ ">Логотип</a><?php echo deployBlock(0); ?>
        </div>
<?php require_once Config::ABCP_COMMON_CODE_PATH . 'ab.visual.form.login.php'; ?>
        <div class=" basketLegendContainer ">
            <div class=" basketLegend ">
<?php if (Session::userIsLoggedIn()) { ?>
                    товаров: <span class=" qty "><?php print $qty; ?></span> шт.<br />
                    на сумму: <span class=" moneySumm "><?php print $moneySummaryView; ?></span> <?php print $siteCurrencyDesignation; ?>
<?php } else { ?>
                    <p>
                        Авторизуйтесь<br/>для работы с корзиной
                    </p>
<?php } ?>
            </div>
            <div class=" cart "><a href="/?p age=trash ">Корзина</a></div>
            <div class=" persCab "><a href="/?p age=orders ">Личный кабинет</a></div>
        </div>
    </div>
    <div class=" baseContent ">
        <div class=" mainAside ">
<?php echo deployMenu(); ?>
        </div>
        <div class=" mainColumn ">
            <div class=" mainArticle ">
<?php
require_once Config::ABCP_COMMON_CODE_PATH . 'ab.visual.form.search.php';
echo deploy_only_search_form();
if ($page == 'catalog') {
    echo deploy_only_results_form();
}
?>
                <div class=" parent-block ">
                <?php
                require_once Config::ABCP_COMMON_CODE_PATH . 'messages/messages.php';
                require_once Config::ABCP_COMMON_CODE_PATH . 'pages/new.page.controllers.factory.php';

                $pageController = NewPageControllersFactory::createPageController($_GET);

                try {
                    $pageController->load();
                } catch (AuthentificationException $e) {
                    echo Message::deployError(Message::AUTHENTIFICATION_WARNING);
                } catch (Exception $e) {
                    echo Message::deployError('Ошибка: ' . $e->getMessage());
                }
                ?>
                </div>
            </div>
        </div>
    </div>
    <div class=" pusher "></div>
</div>
<div class=" foot ">
	<div class=" banners ">
		<a href=" http ://www.abcp.ru/" target=" _blank ">
			<img src=" http ://www.abcp.ru/images/abcp.engine.gif " alt=" Э т о т п о р т а л р а б о т а е т н а п л а т ф о р м е ABCP " title=" Э т о т п о р т а л р а б о т а е т н а п л а т ф о р м е ABCP " />
		</a>
	</div>
    <div class=" copy ">
        &copy; Default2.abcp.ru <?php echo date('Y'); ?><br />
        <a href="/" target=" _blank ">www.default2.abcp.ru</a>
    </div>
    <div class=" counters "><?php echo deployBlock(0); ?></div>
</div>


	puts " moe "
else 
	puts " ne moe "
end	

puts " 2 "
profile = driver.find_element :class => 'clientNameWrapper'
profile.click
sleep 3
puts " 2.1 "




logout = wait.until{driver.find_element :id => 'logout'}
logout.click
sleep 5
puts " 3 "

i=i+1
end

sleep 5
driver.quit

puts " successful "