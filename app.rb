require 'sinatra'
require 'slim'
require 'sqlite3'
require_relative './model.rb'
require 'byebug'

#Väder API
#require 'rubygems'
#require 'bundler'
#Bundler.setup
#require 'sinatra'
require 'json'
require 'rest-client'




get('/') do
  # 1. Hämta titlar, auhtors
  # byebug
  result = get_db.execute("SELECT books.id, books.title, authors.name
    FROM ((book_author_rel
      INNER JOIN books ON book_author_rel.book_id = books.id)
      INNER JOIN authors ON book_author_rel.author_id = authors.id)
      ")
  
    
  slim(:"books/index",locals:{items:result})
end


get('/books/new') do
  slim(:"books/new")
end


post('/books') do
  # 1. Kolla om bok eller author existerar

  # 2. Om båda existerar, redirecta error. 
  #    Om en existerar, hämta dess id, uppdatera db
  
  # 3. Om ingen existerar, lägg till allt i db
  title = params[:title]
  author = params[:author]
  
  #db.transaction #https://zetcode.com/db/sqliteruby/trans/
  
  # 4. Utan transaction

  #EXEMPEL metod som kollar om ngt existerar
  #book = db.execute("select * from books where title = ?", title)
  #if book == []
  #  db.execute("INSERT INTO books (title) VALUES (?)",title)
  #  book = db.execute("select * from books where title = ?", title)
  #end
  
  #titlar (isbn, sidantal, författare)
  #bok (unik streckkod, utlånad) #title_id
  #en titel har många böcker
  #en bok tillhör en titel
  #1. ta bort alla böcker med title_id som är borttaget
  #2. byt title_id på alla böcker som matchar den borttagna titeln till en "fejktitel" som heter "borttagen"
  
  get_db.execute("INSERT INTO books (title) VALUES (?)",title)
  result_book = get_db.execute("SELECT id FROM books WHERE title = ?",title).first
  book_id = result_book["id"]
  get_db.execute("INSERT INTO authors (name) VALUES (?)",author)
  result_author = get_db.execute("SELECT id FROM authors WHERE name = ?",author).first
  author_id = result_author["id"]

  get_db.execute("INSERT INTO book_author_rel (book_id,author_id) VALUES (?,?)",book_id, author_id)
  redirect('/')
  #db.commit
end

#AJAX-test
get('/ajax') do
  slim(:ajaxtest)
end

get('/follower_viz')do
  @user = params[:user]
  slim(:follower)
end

get('/repo_viz')do
  @user = params[:user]
  slim(:repo)
end


#Väder API test
get('/weather/:city') do
  #api.openweathermap.org/data/2.5/forecast?id=524901&appid={API key}
  
  api_result = RestClient.get "http://api.openweathermap.org/data/2.5/weather?q=#{params[:city]}&units=metric&appid=fc06210734c2d2694e4356d622c50ddc"
  jhash = JSON.parse(api_result)
  output = ''

  jhash['main'].each do |w|
    title_tag = w[0]
  info_item = w[1]
    output << "<tr><td>#{title_tag}</td><td>#{info_item}</td></tr>"
end
  
  slim(:weather, :locals => {results: output,city: params[:city]})
end