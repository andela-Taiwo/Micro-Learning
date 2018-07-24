
RSpec.describe Sinatra::App:: SignUp do
  include Rack::Test::Methods
  include Warden::Test::Helpers
  let(:user) { build :user }
  let(:admin)  { build :admin, username: "testadmin5", email: "testadmin@.com" }

  describe "Admin access user " do
    before { login_as FactoryBot.create(:admin, username: "testadmin5", email: "testadmin@.com") }

    context "with valid credentials" do

      it "can view admin dashboard" do
        get "/admin"
        expect(last_response).to be_ok
        expect(last_response.body).to include("Total Topics")
        expect(last_response.body).to include("Total Users")
        expect(last_response.body).to include("Total Resources")
      end

      it "can view users" do
        user2 = FactoryBot.create(:user, username: "testname", email: "e@example.om")
        get "/admin/users"
        expect(last_response).to be_ok
        expect(last_response.body).to include(admin.username)
        expect(last_response.body).to include(admin.email)
        expect(last_response.body).to include(user2.username)
        expect(last_response.body).to include(user2.email)
        expect(last_response.body).to include(user2.admin.to_s)
        expect(user2.admin).to be(false)
      end

      it "can change user admin status" do
        user2 = FactoryBot.create(:user, username: "testname", email: "e@example.om")
        patch "/admin/user/#{user2.id}", params = { admin: true }
        follow_redirect!
        expect(last_response).to be_ok
        user2_new  = User.find_by(email: user2.email)
        expect(last_response.body).to include(admin.username)
        expect(last_response.body).to include(admin.email)
        expect(last_response.body).to include(user2.username)
        expect(last_response.body).to include(user2.email)
        expect(user2_new.admin).to be(true)
      end

      it "can delete user" do
        user2 = FactoryBot.create(:user, username: "testname", email: "e@example.om")
        delete "/admin/user/#{user2.id}/delete"
        follow_redirect!
        expect(last_response).to be_ok
        user2_new = User.find_by(email: user2.email)
        expect(last_response.body).to include(admin.username)
        expect(last_response.body).to include(admin.email)
        expect(user2_new).to be(nil)
      end
    end

    context "with invalid parameters" do

      it "can change non existing user admin status" do
        user2 = FactoryBot.create(:user, username: "testname", email: "e@example.om")
        patch "/admin/user/20", params = {admin: true}
        follow_redirect!
        expect(last_response).to be_ok
        user2_new = User.find_by(email: user2.email)
        expect(last_response.body).to include(admin.username)
        expect(last_response.body).to include("User does not exist.")
        expect(last_response.body).to include(admin.email)
        expect(last_response.body).to include(user2.username)
        expect(last_response.body).to include(user2.email)
      end

      it "can not delete non existing  user" do
        user2 = FactoryBot.create(:user, username: "testname", email: "e@example.om")
        delete "/admin/user/#{64}/delete"
        follow_redirect!
        expect(last_response).to be_ok
        expect(last_response.body).to include(admin.username)
        expect(last_response.body).to include("User does not exist.")
        expect(last_response.body).to include(admin.email)
        expect(last_response.body).to include(user2.email)
      end
    end
  end
end
