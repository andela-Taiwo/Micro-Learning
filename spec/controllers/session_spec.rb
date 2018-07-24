
RSpec.describe Sinatra::App:: LoginSession do
  include Rack::Test::Methods
  include Warden::Test::Helpers
  let(:user) { create :user }

  describe 'Session Controller' do

    before do
      FactoryBot.create(:user)
      FactoryBot.create(:admin)
    end

    it "logs in a user" do
      post "/login", email: "test007@example.com", password: 'test1234'
      follow_redirect!
      expect(last_response).to be_ok
      expect(last_response.body)
          .to include("Successfully logged in")
      expect(last_response.body)
          .to include("Topic")
    end

    it "logs in a admin" do
      post "/login", email: "testadmin@example.com", password: 'test1234'
      follow_redirect!
      expect(last_response).to be_ok
      expect(last_response.body)
          .to include("Admin Dashboard")
      expect(last_response.body)
          .to include("Successfully logged in")
    end

    describe 'logout a user ' do
      before { login_as FactoryBot.create(:admin, username: "admin21") }
      it "logs out user" do

        get "/logout"
        follow_redirect!
        expect(last_response).to be_ok
        expect(last_response.body)
            .to include("Signup")
      end
    end
  end
end
