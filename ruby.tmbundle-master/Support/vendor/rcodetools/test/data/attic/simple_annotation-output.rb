a = 1
10.times do |i|
    i ** 2 # => 0, 1, 4, 9, 16, 25, 36, 49, 64, 81
    a += i
end
A = 1
A = 1 # !> already initialized constant A
