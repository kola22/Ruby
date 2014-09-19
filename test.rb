#!/bin/env ruby
# encoding: utf-8
# Class names must be capitalized.  Technically, it's a constant.

require 'rest-client'

server = "http://test-tecdoc.ru.public.api.abcp.ru/basket/shipmentMethods?userlogin=api@test-tecdoc.ru&userpsw=ace5aad7dfb0ff3830e398c9091149e2"


require 'rest_client'

RestClient.get server, {:params => {:id => 50, 'foo' => 'bar'}}
