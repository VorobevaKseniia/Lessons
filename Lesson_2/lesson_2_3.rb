arr = []
num_1 = 1
num_2 = 0
while num_1 < 100 do
  x = num_1
  num_1 = x + num_2
  num_2 = x
  arr << x
end
print arr