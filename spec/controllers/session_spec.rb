
RSpec.describe Sinatra::App:: LoginSession do
  include Rack::Test::Methods
  include Warden::Test::Helpers
  let(:user) { create :user }
  let(:admin)  { build :admin }
  after { Warden.test_reset! }
  def app
    @app = App
  end
  describe 'Session Controller' do
    before { login_as FactoryBot.create(:admin, username: "testadmin12") }
    it "logs in a user" do
      post "/login", params = {user: attributes_for(:user)}
      follow_redirect!
      expect(last_response).to be_ok
      expect(last_response.body)
          .to include("Successfully logged in")
      expect(last_response.body)
          .to include("Topic")
    end

    it "logs in a admin" do
      post "/login", params = {admin: attributes_for(:user)}
      follow_redirect!
      expect(last_response).to be_ok
      expect(last_response.body)
          .to include("Admin Dashboard")
      expect(last_response.body)
          .to include("Successfully logged in")
    end

    describe 'logout a user ' do
      before { login_as FactoryBot.create(:admin) }
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
