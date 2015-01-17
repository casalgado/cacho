

def modern_roman
	
modern_number = gets.chomp

numerals = ["I", "V", "X", "L", "C", "D", "M"]

	numerals.each_with_index do |num, index|
		if modern_number.include? num*4
			modern_number.gsub!(numerals[index+1]+(num*4), num + numerals[index+2])
			modern_number.gsub!((numeral*4), num + numerals[index+2])
		end
	end

	puts 'new number is'
	puts modern_number
	puts
	puts
	puts

end

while true
	modern_roman
end