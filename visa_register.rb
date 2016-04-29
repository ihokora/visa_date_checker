require 'rubygems'
require 'date'
require 'selenium-webdriver'
require "rspec"
require 'two_captcha'
require_relative 'clicker'


Selenium::WebDriver::Chrome::Service.executable_path = File.join(Dir.pwd, './chromedriver')
@driver = Selenium::WebDriver.for :chrome

wait = Selenium::WebDriver::Wait.new(:timeout => 5)

client = TwoCaptcha.new('996d8cda7f1329a8eae7c9b572af8dc9')

def time
  Time.now.strftime('%a, %Y %b %d %H:%M:%S')  
end

def displayed?(how, what)
  @driver.find_element(how, what).displayed?
  true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
end

puts "2captcha account balance: $#{client.balance}"

print time + " connecting"

loop do
  @driver.get "https://polandonline.vfsglobal.com/poland-ukraine-appointment/(S(050ypg55oonkqejsflpgm445))/AppScheduling/AppWelcome.aspx?P=s2x6znRcBRv7WQQK7h4MTnRfnp06lzlPrFCdHEUl1mc="
  print ". "
  #break if displayed?(:id, "ctl00_plhMain_lnkSchApp")
  break if @driver.title.include?('Poland') == true
end
print "\n"
time
puts "#{time} main page loaded"


# find Призначити дату button 
@driver.find_element(:id, "ctl00_plhMain_lnkSchApp").click
dropdown = @driver.find_element(:id, "ctl00_plhMain_cboVAC")

# dropdown select town
select_list = Selenium::WebDriver::Support::Select.new(dropdown)
select_list.select_by(:text, 'Poland Lviv')

# dropdown select
dropdown = @driver.find_element(:id, "ctl00_plhMain_cboPurpose")
select_list = Selenium::WebDriver::Support::Select.new(dropdown)
select_list.select_by(:text, 'Submission of documents')

# click submit button
@driver.find_element(:id, "ctl00_plhMain_btnSubmit").click



# switch to recaptcha checkbox frame
wait.until{ @driver.find_element(:id, "ctl00_plhMain_grecaptcha") }
@driver.switch_to.frame('undefined')

# click recaptcha checkbox
checkbox = wait.until { @driver.find_element(:id, "recaptcha-anchor") }
checkbox.click

mainWin = @driver.window_handle
@driver.switch_to.window mainWin


if @driver.page_source.include? 'You have selected the VAC at Poland Lviv'
  puts "#{time} text founded"
else
  puts "#{time} text not founded"
end

# SWITCH TO CAPTCHA FRAME 
wait.until { @captchaFrame = @driver.find_element(:css, 'body > div > div:nth-child(4) > iframe') }
@driver.switch_to.frame(@captchaFrame)

puts "#{time} test_1 ok" if displayed?(:id, "recaptcha-verify-button")
puts "#{time} test_2 ok" if @driver.page_source.include? 'Select all images' 

#image = @driver.find_element(:css, "#rc-imageselect-target > table > tbody > tr:nth-child(2) > td:nth-child(2) > div > div.rc-image-tile-wrapper > img")
image = @driver.find_element(:css, "#rc-imageselect-target > table > tbody > tr:nth-child(2) > td:nth-child(2) > div > div.rc-image-tile-wrapper > img")
image_link = image.attribute("src")


instruction_selector = @driver.find_element(:css, "#rc-imageselect > div.rc-imageselect-payload > div.rc-imageselect-instructions > div.rc-imageselect-desc-wrapper > div.rc-imageselect-desc-no-canonical")
instruction = instruction_selector.text
puts instruction

sleep 1


images = @driver.find_elements(:class, 'rc-image-tile-target')
puts images.size


# send captcha to solving
captcha = client.decode(url: image_link, recaptcha: 1, textinstructions: instruction, can_no_answer: 1)
solution = captcha.text.split(//).map(&:to_i)
captcha_id = captcha.id

puts "#{time} click on #{solution[0]}, #{solution[1]} and #{solution[2]} images"
puts "#{time} captcha_id = #{captcha_id}"



index = solution

# clicking on images that comes in response
for i in 0...index.length
	sleep 1
	u = @driver.find_elements(:class, 'rc-image-tile-target')[index[i]-1]
  u.click
  puts "#{time} clicked on #{index[i]} image"  
end

verify_button = @driver.find_element(:css, "#recaptcha-verify-button")
verify_button.click
puts "#{time}'Verify' button clicked"

















=begin
for i in 0...images.size
  u[i] = @driver.find_element(:class, 'rc-image-tile-target')[i]
  u_atrr = u.attribute("css")
  puts u 
end
=end



=begin
u = @driver.find_elements(:class, 'rc-image-tile-target')[2-1]
u_atrr = u
sleep 1
u.click
puts u_atrr
=end
