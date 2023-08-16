# Прямоугольный треугольник

print "Введите первую сторону треугольника"
a = gets.chomp
 
print "Введите вторую сторону треугольника"
b = gets.chomp

print "Введите третью сторону треугольника"
c = gets.chomp

if a.to_i**2 + b.to_i**2 == c.to_i**2 || b.to_i**2 + c.to_i**2 == a.to_i**2 || a.to_i**2 + c.to_i**2 == b.to_i**2
  puts "Треугольник прямоугольный"
elsif (a.to_i == b.to_i && a.to_i != c.to_i) || (a.to_i == c.to_i && a.to_i != b.to_i) || (b.to_i == c.to_i && b.to_i != a.to_i)
  puts "Треугольник равноберденный"
elsif a.to_i == b.to_i && a.to_i == c.to_i
  puts "Треугольник равносторонний"
else
  puts "Ошибка"
end