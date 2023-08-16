# Идеальный вес

print "Ваше имя"
name = gets.chomp
name.capitalize!
 
print "Ваш рост"
height = gets.chomp

puts "#{name}, ваш идеальный вес #{(height.to_i - 110) * 1.15}"