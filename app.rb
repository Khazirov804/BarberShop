#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

# Определяем метод get_db до его использования


configure do
  db = get_db
  db.execute 'CREATE TABLE IF NOT EXISTS
    Users
    (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      phone TEXT,
      datestamp TEXT,
      barber TEXT,
      color TEXT
    )'
end

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

  db = get_db
  db.execute 'insert into
  Users
  (
    name,	
    phone,
    datestamp,
    barber,
    color
  )
  values (?,?,?,?,?)',[@username,@phone,@datetime,@barber,@color]

  erb "OK, Имя:#{@username}, Телефон: #{@phone}, Дата и время: #{@datetime}, Парикмахер: #{@barber}, Цвет: #{@color}" 
end

get '/showusers' do
  erb "Hello World"
end

def get_db
  db = SQLite3::Database.new 'barbershop.db'
  dd.results_as_hach = true
  return db
end