RSpec.describe Topic, :type => :model do
  it 'is invalid without email', :focus => true do
    topic = Topic.new
    topic.should_not be_valid
  end
  it 'is invalid without description', :focus => true do
    topic = Topic.new(title: 'test title')
    topic.should_not be_valid
  end
  it 'is invalid without title', :focus => true do
    topic = Topic.new(description: 'test title')
    topic.should_not be_valid
  end
  it 'is creat topic with valid data', :focus => true do
    topic = Topic.new(title: 'Admin test', description: 'test that topic is created')
    topic.should be_valid
  end
  it 'is invalid if title is blank', :focus => true do
    topic = Topic.new(title: '', description: 'test title')
    topic.should_not be_valid
  end

  it 'is invalid if description  is blank', :focus => true do
    topic = Topic.new(title: 'test title', description: '')
    topic.should_not be_valid
  end
end