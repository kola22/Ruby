#!/bin/env ruby
# encoding: utf-8
#
def show_wait_spinner(fpsx=1)
    chars = %w[| / - \\]  # %w(foo bar) is a shortcut for ["foo", "bar"].
    delay = 1.0/fpsx #1
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
        spinner.join # Возвращает строку, созданную путем преобразования каждого элемента массива в строку, разделенных строкой sep.
        # …and wait for it to do so.
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


asleep 33
