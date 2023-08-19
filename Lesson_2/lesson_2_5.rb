#Заданы три числа, которые обозначают число, месяц, год (запрашиваем у пользователя).
# Найти порядковый номер даты, начиная отсчет с начала года. Учесть, что год может быть високосным.
# (Запрещено использовать встроенные в ruby методы для этого вроде Date#yday или Date#leap?)
# Алгоритм опредления високосного года: docs.microsoft.com

puts "Введите через Enter 3 числа:"
puts "Число"
date = gets.chomp.to_i
puts "Месяц"
month = gets.chomp.to_i
puts "Год"
year = gets.chomp.to_i

number_of_days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

sum = number_of_days.first(month-1).sum.to_i

if year % 4 ==0 && year % 100 == 0 && year % 400 == 0 && month > 2
  sum += date + 1
  puts "Год високосный"
  puts sum
else
  sum += date
  puts sum
end

