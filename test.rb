

text = "Select all images with street numbers. Click verify once there are none left."
puts "yes" if text.include? 'there are none left'

text1 = nil
text1&.split(//)&.map(&:to_i)
puts text1




# @driver = Selenium::WebDriver.for :phantomjs
# @wait = Selenium::WebDriver::Wait.new(:timeout => 5)

# visa = @wait.until { @driver.get "http://polandonline.vfsglobal.com/poland-ukraine-appointment/(S(050ypg55oonkqejsflpgm445))/AppScheduling/AppWelcome.aspx?P=s2x6znRcBRv7WQQK7h4MTnRfnp06lzlPrFCdHEUl1mc=" }
# puts "#{@driver.title}"

# @driver.get "https://google.com"
# puts @driver.title


# @driver.get "http://main.abet.org/aps/accreditedprogramsearch.aspx"
# puts @driver.title









# cells = ["row1", "row2", "row3", "row4", "vvvvv5", "rrrrr6"]

# numbers = Hash[(1...cells.size+1).zip cells]

# print numbers
# puts ""
# index = 2
# puts numbers[index]

# text = "245".split(//).map(&:to_i)
# text = "783"
# puts "click on #{text.split(//).to_s} image"

# def print_response	
# 	text = "245".split(//).map(&:to_i)

# 	for i in 0...text.length
# 		puts "click on #{text[i]} image"
# 	end
# end
# print_response