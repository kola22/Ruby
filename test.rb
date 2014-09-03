#!/bin/env ruby
# encoding: utf-8


# Class names must be capitalized.  Technically, it's a constant.

class Coffe
    def make_coffee
         puts 'Do it'
    end
end

class Capuchino < Coffe
    def createMilk x
        prepare x
        pusht
    end

    private
    def prepare x333
        puts 'Делаем молочише'
        puts x333
    end
    def pusht
        puts 'PUSH'
    end
end

st = 'Проверка пройдена. Цена у клиента без наценки равна цене закупки'
puts st.match(/(?<=\W)\s.*/)


def welcome
    def to
        "RailsClub"
    end
end

require 'benchmark/ips'

Benchmark.ips do |r|
    r.report("mass") do
        a, b, c, d = 1, 2, 3, 4
    end

    r.report("step by step") do
        a = 1
        b = 2
        c = 3
        d = 4
    end
end
