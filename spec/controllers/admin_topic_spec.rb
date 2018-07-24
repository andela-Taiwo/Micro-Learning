
RSpec.describe Sinatra::App:: TopicController do
  include Rack::Test::Methods
  include Warden::Test::Helpers

  after { Warden.test_reset! }
  let(:topic) {create :topic }

  describe 'Admin access topic' do
    before { login_as FactoryBot.create(:admin, username: 'testadmin2') }
    Warden.on_next_request do |proxy|
      proxy.set_user(FactoryBot.create(:admin), :scope => :admin)
    end

    context 'with valid credentials' do

      it 'admin views topics' do
        get '/admin/topic'
        expect(last_response).to be_ok

        expect(last_response.body).to include('Topics')
      end

      it 'add new the topic' do
        post '/admin/topic', params = {topic: attributes_for(:topic)}
        follow_redirect!
        expect(last_response).to be_ok
        expect(last_response.body).to include('Successfully add a new topic')
      end

      it 'edit the topic description ' do
        topic_description = 'The gentle introduction to learning javascript'
        patch "/admin/topic/#{topic.id}",
              params = attributes_for(:topic, description:topic_description)
        follow_redirect!
        expect(last_response).to be_ok
        expect(last_response.body).to include('Successfully updated the topic')
      end

      it 'edit the resource title' do
        patch "/admin/topic/#{topic.id}",
              params = attributes_for(:topic, title: " The new title ")
        follow_redirect!
        expect(last_response).to be_ok
        expect(last_response.body).to include('Successfully updated the topic')
        expect(last_response.body).to include('The new title')
      end

      it 'delete the topic' do
        delete "/admin/topic/#{topic.id}"
        follow_redirect!
        expect(last_response).to be_ok
        expect(last_response.body).to include('Successfully deleted the topic')
      end
    end

    context 'with invalid data set' do

      it 'should not add new the topic when title is blank' do
        post '/admin/topic', params = {topic: attributes_for(:topic, title: ' ')
        }
        follow_redirect!
        expect(last_response).to be_ok
        expect(last_response.body).to include('title is too short (minimum is 6 characters')
      end

      it 'should not add new the topic when description is blank' do
        post '/admin/topic',  params = {topic: attributes_for(:topic, description: ' ')}
        follow_redirect!
        expect(last_response).to be_ok
        expect(last_response.body)
            .to include('description is too short (minimum is 10 characters)')
      end

      it 'when blank title is provided, topic title should remain unchange ' do
        patch "/admin/topic/#{topic.id}",  params = attributes_for(:topic, title: ' ')
        follow_redirect!
        expect(last_response).to be_ok
        expect(last_response.body).to include(topic.title)
        expect(last_response.body).to include("title is too short (minimum is 6 characters)")
      end

      it 'can delete non existing topic ' do
        delete "/admin/topic/#{5}"
        follow_redirect!
        expect(last_response).to be_ok
        expect(last_response.body).to include('Unable to delete the topic')
      end
    end
  end
end
