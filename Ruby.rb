#!/bin/env ruby
# encoding: utf-8

require 'page-object'
require 'selenium/webdriver'

class RegistrationPage
    include PageObject

    page_url "http://www.passport.wapstart.ru/registration/"

    DEFAULT_DATA = {
        'email' => 'habrahabr@gmail.com',
        'password' => 'qwerty',
        'source' => 'Прочитал статью, новость о WapStart'
    }

    text_field(:email, :name => 'mail')
    text_field(:password, :id => 'hidden-password')
    checkbox(:showPassword, :id => 'showPassword')
    select_list(:source, :name => 'informationSource')
    text_field(:fio, :name => 'fio')
    text_field(:phone, :name => 'phone')
    select_list(:purpose, :name => 'registrationPurpose')
    checkbox(:haveCode, :id => 'havePartnerCode')
    text_field(:code, :id => 'plus1PartnerCode')
    checkbox(:agreement, :name => 'agreement')
    button(:register, :name => "register")

    # Exception
    span(:errorCode, :xpath => "//form[@id='registrationForm']/table/tbody/tr[9]/td[2]/span/span[2]")

    def default(data = {})
        populate_page_with DEFAULT_DATA.merge(data)
        check_agreement
        register
    end
end

