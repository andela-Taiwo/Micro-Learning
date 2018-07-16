RSpec.describe User, :type => :model do
  it 'is invalid without email', :focus => true do
    user = User.new
    user.should_not be_valid
  end
  it 'is invalid without password', :focus => true do
    user = User.new(email: 'e.example.com')
    user.should_not be_valid
  end
  it 'is invalid without confirmation password', :focus => true do
    user = User.new(email: 'e.example.com', password: 'testpass')
    user.should_not be_valid
  end
  it 'is invalid when the length of username is less than 3', :focus => true do
    user = User.new(email: 'e.example.com', password: 'testpass', username: 'a', password_confirmation: 'testpass')
    user.should_not be_valid
  end

  it 'is invalid when password does not match', :focus => true do
    user = User.new(email: 'e.example.com', password: 'testpass', username: 'a', password_confirmation: 'testpass23')
    user.should_not be_valid
  end

  it 'is invalid when email is blank', :focus => true do
    user = User.new(email: 'e.example.com', password: 'testpass', username: 'a', password_confirmation: 'testpass23')
    user.should_not be_valid
  end

  it 'is valid when valid data is supplied', :focus => true do
    user = User.new(email: 'e.example.com', password: 'testpass', username: 'testadm', password_confirmation: 'testpass')
    user.should be_valid
  end
end