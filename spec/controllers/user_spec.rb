
RSpec.describe Sinatra::App:: SignUp do
  include Rack::Test::Methods
  include Warden::Test::Helpers
  let(:user) { build :user }
  let(:admin)  { build :admin }

  context "with valid credentials" do
    it "register a user, and send email" do
      post "/signup", params = {user: attributes_for(:user)}
      follow_redirect!
      expect(last_response).to be_ok
      expect(last_response.body)
        .to include("Please confirm your email address to continue")
    end
  end

  context "with invalid credential" do

    it "with a blank email" do
      post "/signup", params = {user: attributes_for(:user, email: " ")}
      follow_redirect!
      expect(last_response).to be_ok
      expect(last_response.body).to include("email can't be blank")
      expect(last_response.status).to eq 200
    end

    it "with short password length" do
      post "/signup", params = {user: attributes_for(:user, password:              "abc",
                                                            password_confirmation: "abc")}
      follow_redirect!
      expect(last_response).to be_ok
      expect(last_response.body)
        .to include("password is too short (minimum is 6 characters)")
    end

    it "with an already registered username" do
      FactoryBot.create(:user)
      post "/signup", params = {user: attributes_for(:user)}
      follow_redirect!
      expect(last_response).to be_ok
      expect(last_response.body).to include("Login")
      expect(last_response.body).to include("username has already been taken")
    end
  end
end
