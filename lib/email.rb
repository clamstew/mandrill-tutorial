require 'rubygems'
require 'bundler/setup'
require 'thin'
require 'mandrill'

class MyEmailer
  def send(email)
    m = Mandrill::API.new
    message = {  
     :subject=> "Hello from the Mandrill API",  
     :from_name=> "Your name",  
     :text=>"Hi message, how are you?",  
     :to=>[  
       {  
         :email=> "#{email}",  
         :name=> "Recipient1"  
       }  
     ],  
     :html=>"<html>&lt;h1&gt;Hi <strong>message</strong>, how are you?</h1></html>",  
     :from_email=>"sender@yourdomain.com"  
    }  
    sending = m.messages.send message  
    puts sending
  end
end
