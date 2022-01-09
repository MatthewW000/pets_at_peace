require 'pg'
require 'bcrypt'

puts "creating dummy user"

email = "matt@ga.co"
password = "caketime"


conn = PG.connect(dbname: 'pets_at_peace')

password_digest = BCrypt::Password.create(password)

sql = "insert into users (email, password_digest) values ('#{email}', '#{password_digest}');"


conn.exec(sql)
conn.close

puts "done"


