require 'pg'

def db_query(sql, params = [])
    conn = PG.connect(dbname: 'pets_at_peace')
    result = conn.exec_params(sql, params)
    conn.close 
    return result 
end

def all_pets()
    db_query('select * from pets order by name;')
end

def create_pets(name, image_url)
    sql = "insert into pets (name, image_url) values ($1, $2)"
    db_query(sql, [name, image_url])
end


def delete_pets(id)
    db_query("delete from pets where id = $1;", [id])
end
  
def update_pets(name, image_url, id)
    sql = "update pets set name = $1, image_url = $2 where id = $3;"
    db_query(sql, [name, image_url, id])
end





