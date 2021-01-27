require 'sinatra'
require 'slim'
require 'sqlite3'


helpers do
  def db
    db = SQLite3::Database.new('db/books.db')
    db.results_as_hash = true
    return db
  end
end

get('/') do
  # 1. Hämta titlar, auhtors
  result = db.execute("SELECT books.id, books.title, authors.name
    FROM ((book_author_rel
      INNER JOIN books ON book_author_rel.book_id = books.id)
      INNER JOIN authors ON book_author_rel.author_id = authors.id)
      ")
  p result


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
  # 4. Utan transaction
  db.execute("INSERT INTO books (title) VALUES (?)",title)
  result_book = db.execute("SELECT id FROM books WHERE title = ?",title).first
  book_id = result_book["id"]
  db.execute("INSERT INTO authors (name) VALUES (?)",author)
  result_author = db.execute("SELECT id FROM authors WHERE name = ?",author).first
  author_id = result_author["id"]

  db.execute("INSERT INTO book_author_rel (book_id,author_id) VALUES (?,?)",book_id, author_id)
  redirect('/')
end