require 'pg'
require 'bcrypt'
require 'pry'


def create_user(email, password)

    password_digest = BCrypt::Password.create(password)

    sql = "insert into users (email, password_digest) values($1, $2)"
    db_query(sql, [email, password_digest])
end

def create_comment(pet_id, body)


    user_id = session['user_id']
    sql = "select email from users where id = $1"
    user_email = db_query(sql, [user_id]).first
    
    
    sql = "insert into comments ( pet_id, body, user_id) values($1, $2, $3)"
    db_query(sql, [ pet_id, body, user_id ])

end

