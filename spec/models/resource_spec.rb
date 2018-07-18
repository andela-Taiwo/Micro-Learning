RSpec.describe Resource, type: :model do
  it 'should have valid Factory' do
    expect(FactoryBot.create(:resource)).to be_valid
  end

  describe 'Validations' do
    context 'should not have a invalid title' do
      it 'is blank title', :focus => true do
        topic = Resource.new(title: '', description: 'test title',
                             url: 'https://learninruby.com')
        topic.should_not be_valid
      end
      it 'title too short', :focus => true do
        topic = Resource.new(title: 'tes',
                             description: 'Element of testing short descr.',
                             url: 'https://learninruby.com')
        topic.should_not be_valid
      end
    end
    context 'should not have a invalid description' do
      it 'is blank description', :focus => true do
        topic = Resource.new(title: 'test title', description: '',
                             url: 'https://learninruby.com')
        topic.should_not be_valid
      end
      it 'description too short', :focus => true do
        topic = Resource.new(title: 'test title', description: 'Element',
                             url: 'https://learninruby.com')
        topic.should_not be_valid
      end
    end
    context 'should not have a invalid url' do
      it 'is blank url', :focus => true do
        topic = Resource.new(title: 'test title',
                             description: 'The url is not valid for this resource',
                             url: '')
        topic.should_not be_valid
      end
      it 'description too short', :focus => true do
        topic = Resource.new(title: 'test title', description: 'Element',
                             url: 'https://learninruby.com')
        topic.should_not be_valid
      end
    end
  end
end