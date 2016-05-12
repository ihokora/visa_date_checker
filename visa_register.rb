require 'rubygems'
require 'date'
require 'selenium-webdriver'
require "rspec"
require 'two_captcha'


def time
  Time.now.strftime('%Y %b %d %H:%M:%S')  
end

def driver_setup
  Selenium::WebDriver::Chrome::Service.executable_path = File.join(Dir.pwd, './chromedriver')
  @driver = Selenium::WebDriver.for :chrome 
  # @driver = Selenium::WebDriver.for :phantomjs
  @wait = Selenium::WebDriver::Wait.new(:timeout => 5)  
end    

class PageDriver

  attr_reader :driver

  def initialize(driver)
    @driver = driver    
  end

  def find(how, locator)
    driver.find_element(how, locator)
  end

  def displayed?(how, what)
    driver.find_element(how, what).displayed?
  true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end  

  def visit  # get the main page
    print  "#{time} connecting"    
    loop do
      begin
        driver.get "http://polandonline.vfsglobal.com/poland-ukraine-appointment/(S(050ypg55oonkqejsflpgm445))/AppScheduling/AppWelcome.aspx?P=s2x6znRcBRv7WQQK7h4MTnRfnp06lzlPrFCdHEUl1mc="
      rescue Net::ReadTimeout
        nil
        puts "#{time} Net::ReadTimeout error :-("
      end

      print ". "
      sleep 1
      # break if displayed?(:id, "ctl00_plhMain_lnkSchApp")
      break if driver.title.include?('Poland') == true
    end
    print "\n"
    puts "#{time} main page loaded"
  end

  def verify_page
    if driver.page_source.include?('You have selected the VAC at Poland Lviv')
      puts "#{time} text founded"
    else
      puts "#{time} text not founded"
    end  
  end 

   
  def go_throuth
    begin
      # find Призначити дату button 
      driver.find_element(:id, "ctl00_plhMain_lnkSchApp").click
          
      # dropdown select town
      dropdown_town = wait_for { driver.find_element(:id, "ctl00_plhMain_cboVAC") }
      select_list = Selenium::WebDriver::Support::Select.new(dropdown_town)
      select_list.select_by(:text, 'Poland Lviv')
      
      # dropdown select purpose
      dropdown_purpose = driver.find_element(:id, "ctl00_plhMain_cboPurpose")
      select_list = Selenium::WebDriver::Support::Select.new(dropdown_purpose)
      select_list.select_by(:text, 'Submission of documents')
      
      # click submit button
      driver.find_element(:id, "ctl00_plhMain_btnSubmit").click
    rescue Net::ReadTimeout
      exit
    end

  end



  def switch_to_captcha_frame
    # switch to recaptcha checkbox frame
    wait_for { driver.find_element(:id, "ctl00_plhMain_grecaptcha") }
    driver.switch_to.frame('undefined')
    
    # click recaptcha checkbox
    checkbox = wait_for { driver.find_element(:id, "recaptcha-anchor") }
    checkbox.click
  end

  def switch_to_default
    mainWin = driver.window_handle
    driver.switch_to.window mainWin
  end

  def wait_for(seconds=5)
    Selenium::WebDriver::Wait.new(:timeout => seconds).until { yield }
  end
  
  

end




class CaptchaSolver < PageDriver
  
  def initialize(driver)
      super
      visit            
  end 
       
  def setup_2captcha_client 
    @client = TwoCaptcha.new('996d8cda7f1329a8eae7c9b572af8dc9')  
    puts "#{time} 2captcha account balance: $#{@client.balance}"
  end

  def switch_to_captcha_challenge  # SWITCH TO CAPTCHA FRAME     
    captchaFrame = wait_for { find(:css, "body > div > div:nth-child(4) > iframe") }
    driver.switch_to.frame(captchaFrame)
  end

  def test_captcha_availability
    puts "#{time} test_1 ok" if displayed?(:id, "recaptcha-verify-button")
    puts "#{time} test_2 ok" if driver.page_source.include? 'Select all' 
  end 

  def get_capthca_parametrs
    image = @driver.find_element(:css, "#rc-imageselect-target > table > tbody > tr:nth-child(2) > td:nth-child(2) > div > div.rc-image-tile-wrapper > img")
    @image_link = image.attribute("src")  
    
    instruction_selector = driver.find_element(:css, "#rc-imageselect > div.rc-imageselect-payload > div.rc-imageselect-instructions > div.rc-imageselect-desc-wrapper > div.rc-imageselect-desc-no-canonical")
    @instruction = instruction_selector.text
          
    images = wait_for { driver.find_elements(:class, 'rc-image-tile-target') }
    puts "#{time} #{@instruction} #{images.size}"    
  end
 
  
  def solve_captcha  # send captcha to 2captcha
    if @instruction.include? 'there are none left'
      puts "#{time} there is refreshable captcha :-("
    else  
      captcha = @client.decode(url: @image_link, recaptcha: 1, textinstructions: @instruction)    
      @solution = captcha.text
      captcha_id = captcha.id    
      puts "#{time} 2captcha response: #{@solution}, captcha_id = #{captcha_id}"      
      image_clicker
    end
  end  
  
  
  def image_clicker  # clicking on images that comes in response
    index = @solution.split(//).map(&:to_i)    
    for i in 0...index.length
    	sleep 1
    	u = driver.find_elements(:class, 'rc-image-tile-target')[index[i]-1]
      u.click
      puts "#{time} clicked on #{index[i]} image"  
    end
  end

end

  
def click_verify_select_type  
  sleep 1
  
  verify_button = @driver.find_element(:css, "#recaptcha-verify-button")
  verify_button.click
  puts "#{time} 'Verify' button clicked"
  
  
  sleep 1
  @driver.switch_to.default_content
  # select type of visa
  dropdown_visa_type = @driver.find_element(:id, "ctl00_plhMain_cboVisaCategory")
  select_list = Selenium::WebDriver::Support::Select.new(dropdown_visa_type)
  select_list.select_by(:text, 'National Visa')
end

def text_present?(text)
  @driver.page_source.include? text    
end

def teardown
  @driver.quit
end


def realtime # :yield:
  r0 = Time.now
  yield
  Time.now - r0
end

def result_message
  message = @wait.until { @driver.find_element(:id, 'ctl00_plhMain_lblMsg') }
  @message = message.text
  puts "#{time} #{@message}"
end