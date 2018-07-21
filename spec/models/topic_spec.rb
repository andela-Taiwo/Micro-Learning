
RSpec.describe Topic, type: :model do
  it 'should have valid Factory' do
    expect(FactoryBot.create(:topic)).to be_valid
  end

  describe 'Validations' do
    context 'should not have a invalid title' do
      it 'is blank title', :focus => true do
      topic = Topic.new(title: '', description: 'test title')
      expect(topic).to_not be_valid
      end
      it 'title too short', :focus => true do
        topic = Topic.new(title: 'tes', description: 'Element of testing short descr.')
        expect(topic).to_not be_valid
      end
    end
    context 'should not have a invalid descripton' do
      it 'is blank description', :focus => true do
        topic = Topic.new(title: 'test title', description: '')
        expect(topic).to_not be_valid
      end
      it 'description too short', :focus => true do
        topic = Topic.new(title: 'test title', description: 'Element')
        expect(topic).to_not be_valid
      end
    end
  end
end
