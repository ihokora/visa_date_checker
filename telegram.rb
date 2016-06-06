require 'rubygems'
require 'telegram/bot'

# @message = "Test 4 send to alex and to igor and to group simultaneously"

def telegram text
  token = '207719716:AAG2aUEnBhQbXnwCr0Km8b0go3XgANbAw3I'  
  bot = Telegram::Bot::Client.new(token)  

  recipients = ['35330414','43375725','-142478552']

  recipients.each do |recipient|
    begin      
      bot.api.send_message(chat_id: recipient, text: text)
    rescue Telegram::Bot::Exceptions::ResponseError => e
      nil
      
    end
  end
  
end

# telegram














# -142478552
# Telegram::Bot::Client.run(token) do |bot| 35330414, 43375725 '@VisaRegistratorReport' '-142478552'
#   bot.listen do |message|
#     case message.text
#     when '/start'

    	
#     when '/hello'
#       bot.api.send_message(chat_id: message.chat.id, text: "Hello #{message.from.first_name}, welcome to Poland Visa Registrator")
#       puts message.chat.id       
#     end
#   end
