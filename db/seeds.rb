users = [
  { username: 'jonsnow', email: 'e@example.com',
    password: 'testadmin1' },
  { username: 'katefoster', email: 'test@example.com',
    password: 'testadmin2' },
  { username: 'queenkate', email: 'admin@example.com',
    password: 'testadmin3' },
]

users.each do |user|
  User.create(user)
end
