#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
	erb :contacts
end

get '/' do
	erb :index
end

post '/visit' do

	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]

	# hash
	hh = {:username =>'Введите имя',
			:phone => 'Введите телефон',
			:datetime => 'Введите дату и время'}
	@error = hh.select {|key,_| params[key] == ""}.values.join(",")

	if @error != ''
		return erb :visit
	end

	f = File.open './public/users.txt', 'a'
	f.write "Имя: #{@username}, Телефон: #{@phone}, Дата и время: #{@datetime}, Парикмахер: #{@barber}, Цвет: #{@color} "
	f.close
	erb "OK, Имя:#{@username}, Телефон: #{@phone}, Дата и время: #{@datetime}, Парикмахер: #{@barber}, Цвет: #{@color} "
end

post '/contacts' do
	@email = params[:email]



	f = File.open './public/users.txt', 'a'
	f.write "Email: #{@email} "
	f.close
	erb :contacts
end
