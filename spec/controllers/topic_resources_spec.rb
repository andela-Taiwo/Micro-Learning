
RSpec.describe Sinatra::App:: TopicResourceController do
  include Rack::Test::Methods
  include Warden::Test::Helpers

  after { Warden.test_reset! }
  let(:user) { build :user }
  let(:resource) { create :resource }
  let(:topic) { create :topic, resources: [resource] }
  let(:sinatra) do
    create :resource,
           title: 'Intro to Sinatra',
           description: 'The second sinatra resource', url: 'https://wee.com/sinatra'
  end

  let(:rails) do
    create :resource,
           title: 'Intro to Rails',
           description: 'The second rails resource', url: 'https://wee.com/rails'
  end
  describe 'Admin access resource' do
    before { login_as FactoryBot.create(:admin, username: 'testadmin3') }

    context 'with valid credentials' do
      it 'admin views topics resources' do
        get "/admin/topic/#{topic.id}/resources"
        expect(last_response).to be_ok
        expect(last_response.body).to include('Topics')
        expect(last_response.body).to include("#{topic.title}")
        expect(last_response.body).to include(resource.title)
        expect(last_response.body).to include(resource.url)
      end

      it 'admin views topic single resource' do
        get "/admin/topic/#{topic.id}/resource/#{resource.id}"
        expect(last_response).to be_ok
        expect(last_response.body).to include("#{topic.title}")
        expect(last_response.body).to include(resource.title)
        expect(last_response.body).to include(resource.url)
      end

      it 'admin delete single resource' do
        delete "/admin/topic/#{topic.id}/resource/#{resource.id}"
        follow_redirect!
        expect(last_response).to be_ok
        expect(last_response.body).to include("Successfully remove the resource.")
        expect(last_request.path).to eq("/admin/topic/#{topic.id}/resources")
        expect(last_response.body).to include(topic.title)
      end

      it 'add new resources to a topic' do
        post "/admin/topic/#{topic.id}/resources",
             params = {topic: attributes_for(:topic, resource_ids: ["#{rails.id}", "#{sinatra.id}"])}
        follow_redirect!
        expect(last_response).to be_ok
        expect(last_response.body).to include('Resource successfully added to the topic.')
        expect(last_response.body).to include(sinatra.title)
        expect(last_response.body).to include(rails.title)
        expect(last_response.body).to include(sinatra.url)
      end

      context 'with invalid data set' do
        it 'admin can not adds the same resource twice for a topic ' do
          topics =  FactoryBot.create :topic, title: 'Testing resource', resources: [sinatra, rails]
          post "/admin/topic/#{topics.id}/resources",
               params = {topic: attributes_for(:topic, resource_ids: ["#{rails.id}", "#{sinatra.id}"])}
          follow_redirect!
          expect(last_response).to be_ok
          expect(last_response.body)
              .to include("The resource #{sinatra.title} already exist for the topic.")
          expect(last_request.path). to eq ("/admin/topic/#{topics.id}/resources")
        end

        it 'can not delete non existing resource ' do
          delete "/admin/topic/#{topic.id}/resource/#{45}"
          follow_redirect!
          expect(last_response).to be_ok
          expect(last_response.body).to include("Unable to delete the resource")
          expect(last_request.path).to eq("/admin/topic/#{topic.id}/resources")
          expect(last_response.body).to include(topic.title)
        end
      end
    end
  end
end
