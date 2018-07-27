RSpec.describe Sinatra::App:: LoginSession do
  include Rack::Test::Methods
  include Warden::Test::Helpers
  let(:user) { create :user }

  describe "Session Controller" do
    before do
      FactoryBot.create(:user)
      FactoryBot.create(:admin)
    end

    context "with valid data" do
      it "logs in a user" do
        post "/login", email: "test007@example.com", password: "test1234"
        follow_redirect!
        expect(last_response).to be_ok
        expect(last_response.body).
          to include("Successfully logged in")
        expect(last_response.body).
          to include("Topic")
      end

      it "logs in a admin" do
        post "/login", email: "testadmin@example.com", password: "test1234"
        follow_redirect!
        expect(last_response).to be_ok
        expect(last_response.body).
          to include("Admin Dashboard")
        expect(last_response.body).
          to include("Successfully logged in")
      end

      describe "already login user" do
        before { login_as FactoryBot.create(:admin, username: "admin21") }

        it "redirect to topic page" do
          get "/login"
          follow_redirect!
          expect(last_response).to be_ok
          expect(last_request.path).to eq("/topics")
        end

        it "redirect to home page" do
          get "/signup"
          follow_redirect!
          expect(last_response).to be_ok
          expect(last_request.path).to eq("/")
        end
      end

      describe "logout a user " do
        before { login_as FactoryBot.create(:admin, username: "admin21") }

        it "logs out user" do
          get "/logout"
          follow_redirect!
          expect(last_response).to be_ok
          expect(last_response.body).
            to include("Signup")
        end
      end
    end

    context "with invalid data" do
      describe "login user with wrong password or email" do
        it "redirect to login page with wrong password" do
          post "/login", email: "testadmin@example.com", password: "invalid"
          follow_redirect!
          expect(last_response).to be_ok
          expect(last_response.body).to include("Incorrect Email or Password")
          expect(last_request.path).to eq("/login")
        end

        it "redirect to login page with wrong email" do
          post "/login", email: "testwrong@example.com", password: "test1234"
          follow_redirect!
          expect(last_response).to be_ok
          expect(last_response.body).to include("Incorrect Email or Password")
          expect(last_request.path).to eq("/login")
        end
      end
    end
  end
end
