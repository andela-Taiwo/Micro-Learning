require "rspec-sidekiq"
Sidekiq::Testing.fake!
RSpec.describe Sinatra::App:: UserResourceController do
  include Rack::Test::Methods
  include Warden::Test::Helpers
  after { Warden.test_reset! }

  let(:resource) {
    FactoryBot.create(:resource, title: "The Winds of Winter",
                                 url:   "http://odinproject.com/beginner")
  }
  let(:topic) { FactoryBot.build :topic, resources: [resource] }

  describe "User resource" do
    before { login_as FactoryBot.create(:user, topics: [topic]) }

    context "with valid credentials" do
      it "user can view topic's resource" do
        get "/user/topics/#{topic.id}/resource"
        expect(last_response).to be_ok
        expect(last_response.body).to include(resource.title.to_s)
        expect(last_response.body).to include(resource.url.to_s)
      end
    end

    context "with invalid data set" do
      it "user can not view non existing topic's resource " do
        get "/user/topics/1000/resource"
        expect(last_response).to be_ok
        expect(last_response.body).to include("Topic does not exist")
      end
    end
  end
end
