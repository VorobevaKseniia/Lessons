alphabet = ('a'..'z').to_a
vowels = "aeiou"

vowel_hash = {}

alphabet.each_with_index do |letter, index|
  if vowels.include?(letter)
    vowel_hash[letter] = index + 1
  end
end
print vowel_hash
