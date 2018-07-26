require "rspec-sidekiq"
Sidekiq::Testing.fake!

RSpec.describe Sinatra::App:: TopicController do
  include Rack::Test::Methods
  include Warden::Test::Helpers
  after { Warden.test_reset! }

  let(:topic) { FactoryBot.create :topic }
  let(:topic2) do
    FactoryBot.create :topic,
                      title: "Testing topic", description: "The long description on ruby"
  end

  let(:user) { FactoryBot.build :user, topics: [topic] }

  let(:admin)  { build :admin }

  before do
    FactoryBot.build_stubbed :topic,
                             title:       "Testing topic",
                             description: "The long description on ruby"
  end

  before { login_as FactoryBot.create(:user, topics: [topic]) }

  context "with valid credentials" do
    it "user views topics" do
      get "/topics"
      expect(last_response).to be_ok
      expect(last_response.body).to include("Topics")
    end

    it "user views topic resource" do
      get "/user/topics/#{topic.id}/resource"
      expect(last_response).to be_ok
      expect(last_response.body).to include("No resource yet for the course")
    end

    it "user views topic detail" do
      get "/topic/#{topic.id}"
      expect(last_response).to be_ok
      expect(last_response.body).to include(topic.title)
    end

    it "sends email, when a user enrolls for a topic " do
      time = 5.minutes.from_now
      post "/user/topics/#{topic2.id}"
      args = "enrollment", user.email, user.username, topic.title, true
      follow_redirect!
      MailWorker.perform_at time, args
      expect(last_response).to be_ok
      expect(last_response.body).
        to include("Successfully add a new topic to your learning path")
      expect(last_response.body).to include("Enrolled Courses")
      expect(last_response.body).to include(user.username.capitalize)
      expect(MailWorker).to have_enqueued_sidekiq_job(args).at(time)
    end

    it "user un-follows  a topic " do
      delete "/user/topic/#{topic.id}"
      follow_redirect!
      expect(last_response).to be_ok
      expect(last_response.body).to include("Successfully deleted the topic")
      expect(last_response.body).to include("Enrolled Courses")
      expect(last_response.body).
        to include(user.username.capitalize)
    end
  end

  context "with invalid data set" do
    it "user enrolls twice for a topic " do
      post "/user/topics/#{topic2.id}"
      post "/user/topics/#{topic2.id}"
      follow_redirect!
      expect(last_response).to be_ok
      expect(last_response.body).
        to include("You have already added the topic.")
      expect(last_request.url). to include "/topics"
    end
  end
end
