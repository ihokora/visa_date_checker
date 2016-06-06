require 'telegram/bot'
load './visa_register.rb'
load './telegram.rb'

class Selenium::WebDriver::Error::NoSuchElementError
end

def go_to_end
  driver_setup  
  bot = CaptchaSolver.new(@driver)  
  
  bot.go_throuth
  bot.verify_page

  bot.switch_to_captcha_frame
  bot.switch_to_default  
  
  bot.switch_to_captcha_challenge_x

  bot.setup_2captcha_client
  # sleep 1
  bot.test_captcha_availability
  # sleep 1
  bot.get_capthca_parametrs
  # sleep 1
  bot.solve_captcha

  click_verify_select_type
  result_message
end

def restart
  teardown
  check_free_date
end

def check_free_date
  loop do 
    go_to_end	
    break if text_present? 'The next available'
    puts "#{time} #{@message} "
    teardown
    telegram @message
  end          
end

check_free_date




at_exit { puts  "#{time} ...done" }