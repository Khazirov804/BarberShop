#encoding: utf-8
require 'rubygems'
require 'sinatra' # Подключаем фреймворк Sinatra для создания веб-приложений.
require 'sinatra/reloader' # Подключаем модуль для автоматической перезагрузки приложения при изменении кода.
require 'sqlite3' # Подключаем библиотеку для работы с базой данных SQLite3.

def is_barber_exists? db,username
	db.execute('select * from barbers where username=?', [username]).length > 0
end

def seed_db db, barbers

	barbers.each do |barber|
		if !is_barber_exists? db, barber
			db.execute 'insert into barbers (username) values (?)', [barber]
		end
	end
end

# Метод для создания подключения к базе данных.
def get_db
  db = SQLite3::Database.new 'barbershop.db' # Создаем или открываем базу данных с именем 'barbershop.db'.
  db.results_as_hash = true # Настраиваем базу данных, чтобы результаты запросов возвращались в виде хэша, где имена колонок используются как ключи.
  return db # Возвращаем объект базы данных.
end

before do
	db = get_db
	@barbers = db.execute 'select * from barbers'
end

# Конфигурация приложения, выполняется один раз при запуске.
configure do
  db = get_db # Получаем подключение к базе данных.
  # Создаем таблицу Users, если она еще не существует.
  #execute используется для выполнения SQL-запросов к базе данных.
  #Он является частью библиотеки sqlite3 и позволяет отправлять запросы в базу данных SQLite.
  db.execute 'CREATE TABLE IF NOT EXISTS
    Users
    (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT, -- Имя пользователя.
      phone TEXT, -- Телефон пользователя.
      datestamp TEXT, -- Дата и время записи.
      barber TEXT, -- Имя парикмахера.
      color TEXT -- Предпочитаемый цвет.
    )'
  db.execute 'CREATE TABLE IF NOT EXISTS
    barbers
    (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT
    )'

    seed_db db, ['Jessie Pinkman', 'Walter White', 'Gus Fring', 'Mike Ehrmantraut']
end

# Главная страница приложения.
# Обрабатывает GET-запрос на корневой URL ('/'). 
get '/' do
  erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>" 
end

# Страница "О нас".
# Обрабатывает GET-запрос на '/about'.
get '/about' do
  erb :about # Рендерим шаблон about.erb.
end

# Страница записи на прием.
# Обрабатывает GET-запрос на '/visit'.
get '/visit' do
  erb :visit # Рендерим шаблон visit.erb.
end

# Страница контактов.
# Обрабатывает GET-запрос на '/contacts'.
get '/contacts' do
  erb :contacts # Рендерим шаблон contacts.erb.
end

# Повторное определение маршрута для главной страницы.
# Этот маршрут перекрывает предыдущий get '/' выше.
get '/' do
  erb :index # Рендерим шаблон index.erb.
end

# Обработка данных, отправленных с формы записи на прием.
# Обрабатывает POST-запрос на '/visit'.
post '/visit' do
  # Получаем данные из формы. 
  # params — это хэш, содержащий параметры, переданные с формы через HTTP-запрос (GET или POST).
  # Например, params[:username] вернет значение, введенное пользователем в поле с именем "username".
  @username = params[:username]
  @phone = params[:phone]
  @datetime = params[:datetime]
  @barber = params[:barber]
  @color = params[:color]

  # Хэш для проверки обязательных полей.
  hh = {
    :username => 'Введите имя', # Сообщение, если поле "Имя" не заполнено.
    :phone => 'Введите телефон', # Сообщение, если поле "Телефон" не заполнено.
    :datetime => 'Введите дату и время' # Сообщение, если поле "Дата и время" не заполнено.
  }

  # Проверяем, заполнены ли обязательные поля, и формируем сообщение об ошибке.
  # Используем метод select для выбора незаполненных полей из хэша hh.
  @error = hh.select { |key, _| params[key] == "" }.values.join(",")

  # Если есть ошибки, перерисовываем страницу с формой записи.
  if @error != ''
    return erb :visit # Возвращаем пользователю ту же страницу с ошибками.
  end

  # Сохраняем данные в базу данных.
  db = get_db # Подключаемся к базе данных.
  #execute используется для выполнения SQL-запросов к базе данных.
  #Он является частью библиотеки sqlite3 и позволяет отправлять запросы в базу данных SQLite.
  db.execute 'INSERT INTO 
    Users
    (
      name, -- Имя пользователя.
      phone, -- Телефон пользователя.
      datestamp, -- Дата и время записи.
      barber, -- Имя выбранного парикмахера.
      color -- Предпочитаемый цвет.
    )
    VALUES (?, ?, ?, ?, ?)', [@username, @phone, @datetime, @barber, @color] # Передаем параметры в запрос.

  # Возвращаем подтверждение записи.
  erb "<h2>Спасибо, вы записались.</h2>"
end

# Получаем подключение к базе данных
db = get_db

# Выполняем запрос SELECT для извлечения всех пользователей
result = db.execute('SELECT * FROM Users')
# result — это массив хэшей, каждый хэш представляет строку из базы данных
# Каждый хэш будет выглядеть как { 'id' => 1, 'name' => 'John Doe', 'phone' => '1234567890', ... }

# Страница для отображения списка пользователей (пока заглушка).
# Обрабатывает GET-запрос на '/showusers'.
get '/showusers' do
  db = get_db
  # Извлекаем всех пользователей из таблицы Users
  @users = db.execute('SELECT * FROM Users')
  
  # Передаем переменную @users в шаблон showusers.erb для отображения
  erb :showusers
end

