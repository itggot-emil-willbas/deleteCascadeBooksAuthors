
#DETTA...
db = SQLite3::Database.new('db/books.db')

#ISTÄLLET FÖR:
def get_db()
  puts "Connect"
  db = SQLite3::Database.new('db/books.db')
  db.results_as_hash = true
  return db
end

helpers do
  #Om IFRÅN formulär...
  #def select_all(table)
   # select_all = {
    #  "bananas" => "SELECT * FROM bananas",
    #  "apples"  => "SELECT * FROM apples"
    #}
    #return select_all[table]
  #end

  def books(ewi_table)
    query = select_all[ewi_table]
    if query != nil
      result = get_db.execute(select_all[ewi_table])
      #"SELECT * FROM #{ewi_table}")
    end
    return result
  end

  def register(params) 
    #rack flash gem https://github.com/nakajima/rack-flash
    if params['password1'] != params['password2']
      #fel
      session["error"] = {} 
      session["error"]["email"] = "that is not a valid email"
      #redirect back
      email = params['email']
      slim(:register, locals:{email: email})
    else
      #continue
    end
  
  end

end