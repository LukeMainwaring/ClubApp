json.extract! user, :id, :firstName, :lastName, :email, :password, :position, :created_at, :updated_at
json.url user_url(user, format: :json)
