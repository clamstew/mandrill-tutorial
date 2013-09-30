<h3>Using Mandrill Email API</h3>

I was working on a hackathon project last weekend, and we need a quick way to send emails out from our Sinatra application. At first we tried to integrate the <a href="https://rubygems.org/gems/gmail" target="_blank">gmail gem</a>, but after realizing that is an easy way to get that account flagged at spam, we decided to turn to Mandrill by Mailchimp.

I'll show you how to
<ul>
	<li>integrate the Mandrill API</li>
	<li>how to send mail with the Mandrill API</li>
	<li>and some quick advanced features in the mandrill API</li>
	<ul>
		<li>How to send with multiple users in To and other fields</li>
		<li>How to suppress users from the To field</li>
		<li>How to use the Mandrill Test Key to make the email call but not actually push out an email to count against your monthly API call limit.</li>
		<li>How to use "Merge Fields" in Mandrill to merge in custom URL's and data into the email about the user you are sending to.</li>
	</ul>
</ul>

__________________________

<h4>Example APP: My Penpal</h4>

We are going to build a quick application to send emails out to users who subscribe to your mailing list.  

I created a bare bones Rails App for this tutorial on using Mandrill.

__But first, lets get a Mandrill account.__

<h4>Get API Key:</h4>
Go to [https://mandrill.com/signup/](https://mandrill.com/signup/) and *set up a quick FREE acount*.  You just got 12,000 emails per month!

After you create an account, *Login*. 

(Take note of your login info somewhere.)

__________________________

Open up this link: [Most useful page for getting started with the Ruby Gem](http://help.mandrill.com/entries/23257181-Using-the-Mandrill-Ruby-Gem). This was a good basic look at the Mandrill API send email function with the <code>gem 'madrill-api'</code> which will go in your gem file.</code>

__STEP 1:__ add <code>gem 'madrill-api'</code> in your <code>Gemfile</code>

<pre>
source 'https://rubygems.org'

gem 'sinatra'
gem 'sinatra-contrib'
gem 'thin'
gem 'mandrill-api'
</pre>

__STEP 2:__ run <code>$ bundle install</code>

__STEP 3:__ run <code>$ touch .env</code> to create a <code>.env</code> file.

__STEP 4:__ Go to [https://mandrillapp.com/settings/index](https://mandrillapp.com/settings/index) -> the __"SMTP & API Credentials"__ page. Create a new API key.
 
Add the following to your <code>.env</code> file:

<pre>
MANDRILL_APIKEY = 'xxxxxxxxxxxxxxxxxxxxx' #test or the #real one
</pre>

As [this getting going page](http://help.mandrill.com/entries/23257181-Using-the-Mandrill-Ruby-Gem) says: <code>The gem assumes your API key is stored as an environment variable called MANDRILL_APIKEY.</code>. So it goes in the <code>.env</code> file and requires no setup beyond that.

__STEP 5:__ add a new folder called <code>lib/</code> with <code>$ mkdir lib</code>

__STEP 6:__ add a new file in there called <code>lib/email.rb</code>

__STEP 7:__ make a basic ruby class called <code>class MyEmailer</code> in <code>email.rb</code> and also add the '<code>requires</code>' statements that match the <code>Gemfile</code> at the top. We will also add an empty <code>MyEmailer#send</code> method to the new class.

__-------STRANGE THING TO NOTE HERE:__ The gem is <code>gem 'madrill-api'</code> and the require is <code>require 'mandrill'</code>.  Not the same. Confusing.


<code>email.rb</code> at this point:
<pre>
require 'rubygems'
require 'bundler/setup'
require 'thin'
require 'mandrill'

class MyEmailer
  def send
  end
end
</pre>

   Also add the Mandrill require line to your main Sinatra file: <code>mandrill-tutorial.rb</code>:

<pre>
require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'sinatra/reloader'
require 'thin'				  ## ALSO THIS FOR FOREMAN
require 'mandrill'           ## ADD THIS LINE HERE


get '/' do
  'Welcome to your Mail Sender app!'
end
</pre>

__STEP 7:__ Run <code>$ bundle install</code>.

__STEP 8:__ Add this code to your <code>MyEmailer#send</code> method:

<pre>
require 'rubygems'
require 'bundler/setup'
require 'mandrill'

class MyEmailer
  def send(email)
  	<strong>
    m = Mandrill::API.new
    message = {  
     :subject=> "Hello from the Mandrill API",  
     :from_name=> "Your name",  
     :text=>"Hi message, how are you?",  
     :to=>[  
       {  
         :email=> "#{email}",  ## this uses the email argument passed into this method
         :name=> "Recipient1"  
       }  
     ],  
     :html=>"<html>&lt;h1&gt;Hi &lt;strong&gt;message&lt;/strong&gt;, how are you?&lt;/h1&gt;</html>",  
     :from_email=>"sender@yourdomain.com"  
    }  
    sending = m.messages.send message  
    puts sending
    </strong>
  end
end
</pre>

__STEP 9:__ Go back to the main Sinatra file <code>mandrill-tutorial.rb</code>:

<pre>
require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'sinatra/reloader'
require 'mandrill'

<strong>require_relative 'lib/email'  ## THIS IS A NEW LINE AT THIS POINT</strong>

get '/' do
  'Welcome to your Penpal app!'
end

<strong>
get '/send/:email' do
  m = MyEmailer.new
  m.send(params[:email])
  "Email Sent"           ## Sinatra likes to print something out .. so this
end
</strong>
</pre>

This will allow you to put in an email address in your browser URI like <code>http://localhost:4567/send/something%40domain.com</code>, and this will send your email into the <code>#send</code> method using GET params.

__STEP 10:__ Run <code>foreman</code> webserver to get going:

<pre>
$ foreman run ruby mandrill-tutorial.rb
</pre>

__STEP 11:__ Go visit your neat new homepage:

<pre>
http://localhost:4567/
</pre>

__STEP 12:__ Go send yourself an email:

<pre>
http://localhost:4567/email/youremailprefix%40something.com
</pre>

__NOTE:__ Fill in your email for: <code>youremailprefix%40something.com</code> in the above URL. Also, <code>%40</code> is <code>@</code> in URL encoding.

__FINAL:__ If you go to the branch in the repo you forked above called <code>$ git checkout final;</code>. This is my finished code from this tutorial, so you can check that it is all there compared to your work. 

___________________________

<h3>Resources:</h3>

[Mandrill: Full Message Calls Documentation](https://mandrillapp.com/api/docs/messages.JSON.html) - for full message calls like adding a more people to the TO field, suppressing recipients, etc. 

[Where to view API Logs](https://mandrillapp.com/settings/api)

__NOTE:__ I had to use FOREMAN by heroku instead of thin or webbrick webserver to get env files to work
__________________________

 