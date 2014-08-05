#!/usr/bin/ruby

require 'open-uri'
url = 'http://habrahabr.ru'
page = open(url)
text = page.read
