cells = ["row1", "row2", "row3", "row4", "vvvvv5", "rrrrr6"]


=begin
numbers = Hash[(1...cells.size+1).zip cells]

print numbers
puts ""
index = 2
puts numbers[index]
=end


text = "245".split(//).map(&:to_i)
print text
puts text[0]
puts text[1]
puts text[2]
puts "'Verify' button clicked"


puts "click on #{text.join(", and ")} image"

def print_response	
	text = "245".split(//).map(&:to_i)

	for i in 0...text.length
		puts "click on #{text[i]} image"
	end
end
print_response