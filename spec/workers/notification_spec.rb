require "rspec-sidekiq"
require_relative "../../app/workers/notification"

RSpec.describe ResourceNotification do
  include Rack::Test::Methods
  include Warden::Test::Helpers
  after { Warden.test_reset! }

  let(:resource) { FactoryBot.create :resource }
  let(:topic) { FactoryBot.create :topic, resources: [resource] }
  let(:topic2) do
    FactoryBot.create :topic,
                      title: "Testing topic", description: "The long description on ruby"
  end

  let(:user) { FactoryBot.build :user, topics: [topic] }

  let(:admin)  { build :admin }

  before do
    FactoryBot.build_stubbed :resource
    FactoryBot.build_stubbed :topic, resources: [resource]
    ResourceNotification.new
  end

  before { login_as FactoryBot.create(:user, topics: [topic]) }

  context "with valid credentials" do
    before { ResourceNotification.new }

    it "sends email containing daily resource" do
      notification = ResourceNotification.new
      notification.perform
      expect(ResourceNotification.jobs.size).to eq(0)
    end
  end
end
