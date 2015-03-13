

# случайный текст определенной длины
def randomTxt (count)
    o = [('a'..'z'), ('A'..'Z')].map{ |i| i.to_a }.flatten
    return string = (0...(count)).map       { o[rand(o.length)] }.join
end
