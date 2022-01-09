     
require 'pry'
require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'bcrypt'

require_relative 'models/pets.rb'
require_relative 'models/user.rb'

enable :sessions

#helper method

def logged_in?()
  if session[:user_id]
    return true
  else 
    return false
  end
end

def current_user()
  sql = "select * from users where id = #{ session[:user_id] };"
  user = db_query(sql).first
  return OpenStruct.new(user)
end

get '/' do
  pets = all_pets()

  erb(:index, locals: {pets: pets})
end

get '/pets/new' do 
  redirect '/login' unless logged_in?

  erb(:new)
end

get '/pets/:id' do 

  pets_id = params['id']

  pets = db_query("select * from pets where id = $1", [pets_id]).first

  comments = db_query("select body from comments")



  erb(:show, locals: { 
    pets: pets,
    comments: comments
   })
end

post '/pets' do 
  redirect '/login' unless logged_in?

  create_pets(params['name'], params['image_url'])

  redirect "/"
end

delete '/pets/:id' do 
  delete_pets(params['id'])

  redirect'/'
end

get '/pets/:id/edit' do 

  sql = "select * from pets where id = $1;"
  pets = db_query(sql, [params['id']]).first 

  erb(:edit, locals: {pets: pets})
end

put '/pets/:id' do 
   update_pets(
     params['name'],
     params['image_url'],
     params['id']
   )

  redirect "/pets/#{params['id']}"
end

get '/login' do 
  erb :login
end

post '/session' do 
  
  email = params["email"]
  password = params["password"]

  conn = PG.connect(dbname: 'pets_at_peace')
  sql = "select * from users where email = '#{email}';"
  result = conn.exec(sql) 
  conn.close 

  if result.count > 0 && BCrypt::Password.new(result[0]['password_digest']).==(password)

    session[:user_id] = result[0]['id']

    redirect '/'
  else
    erb :login
  end
end

delete '/session' do 
  session[:user_id] = nil
  redirect "/login"
end

get '/user' do 
  erb :create 
end

post '/user' do 
  

  create_user(params['email'], params['password'])

  redirect '/'
end

post '/pets/:id/comment' do 

  sql = "select * from pets where id = $1;"
  pet = db_query(sql, [params['id']]).first


  body = params['comment']
  
  create_comment(body)

  redirect "/pets/#{params['id']}"
  

  erb :show, locals: {body: body}
  

end

