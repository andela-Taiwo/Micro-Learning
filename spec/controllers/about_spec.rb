RSpec.describe Sinatra::App:: Home do
  include Rack::Test::Methods
  include Warden::Test::Helpers
  let(:user) { build :user }
  let(:admin)  { build :admin }

  it "view home page" do
    get "/"
    expect(last_response).to be_ok
    expect(last_request.path).to eq("/")
    expect(last_response.body).
      to include("3L")
  end

  it "view about page" do
    get "/about"
    expect(last_response).to be_ok
    expect(last_request.path).to eq("/about")
    expect(last_response.body).
      to include("3L")
  end
end
