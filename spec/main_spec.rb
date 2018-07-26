RSpec.describe Sinatra::App:: Home do
  include Rack::Test::Methods
  def app
    @app = App
  end
  it "allow accessing the home page" do
    get "/"
    expect(last_response).to be_ok
    expect(last_response.body). to include("LIFE     LONG     LEARNER")
  end
end
