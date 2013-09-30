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

__STEP 1:__ put <code>gem 'madrill-api'</code> in your <code>Gemfile</code>

__STEP 2:__ run bundle install

<pre>
MANDRILL_APIKEY = "alskdfjzixcvxkjzlvc" #test or the #real one
</pre>

<pre>
require 'mandrill'  
m = Mandrill::API.new
message = {  
 :subject=> "Hello from the Mandrill API",  
 :from_name=> "Your name",  
 :text=>"Hi message, how are you?",  
 :to=>[  
   {  
     :email=> "recipient@theirdomain.com",  
     :name=> "Recipient1"  
   }  
 ],  
 :html=>"<html>&lt;h1&gt;Hi <strong>message</strong>, how are you?</h1></html>",  
 :from_email=>"sender@yourdomain.com"  
}  
sending = m.messages.send message  
puts sending
</pre>

[Mandrill: Full Message Calls Documentation](https://mandrillapp.com/api/docs/messages.JSON.html)

[Where to view API Logs](https://mandrillapp.com/settings/api)

__________________________

If you go to the branch in the repo you forked above called <code>$ git checkout final-project;</code>. This is my finished code from this tutorial, so you can check that it is all there compared to your work.  