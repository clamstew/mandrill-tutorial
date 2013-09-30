require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'sinatra/reloader'
require 'thin'
require 'mandrill'

require_relative 'lib/email'

get '/' do
  'Welcome to your Mail Sender app!'
end

get '/send/:email' do
  m = MyEmailer.new
  m.send(params[:email])
  "Email Sent"
end
