users = [
  { username: 'jonsnow', email: 'e@example.com',
    password: 'testuser1',  password_confirmation: 'testuser1' },
  { username: 'katefoster', email: 'test@example.com',
    password: 'testuser2', password_confirmation: 'testuser2' },
  { username: 'queenkate', email: 'admin@example.com',
    password: 'testuser3',  password_confirmation: 'testuser3' }
]

users.each do |user|
  User.create(user)
end
