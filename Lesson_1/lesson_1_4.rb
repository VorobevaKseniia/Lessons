# Квадратное уравнение

print "Введите первый коэффицент"
a = gets.chomp

print "Введите второй коэффицент"
b = gets.chomp

print "Введите третий коэффицент"
c = gets.chomp

d = (b.to_i**2 - 4*a.to_i*c.to_i)


if d.to_i > 0
  x1 = (-b.to_i + Math.sqrt(d))/(2*a.to_i)
  x2 = (-b.to_i - Math.sqrt(d))/(2*a.to_i)
  puts "Корни уравнения: #{x1}, #{x2}"

elsif d.to_i == 0
  x = -b.to_i/(2*a.to_i)
puts "Корень уровнения: #{x}"

else
  puts "Корней нет"
end