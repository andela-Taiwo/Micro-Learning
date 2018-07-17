
RSpec.describe Sinatra::App:: SignUp do
  include Rack::Test::Methods
  include Warden::Test::Helpers
  def app
    @app = App
  end
  it "should allow accessing the signup page" do
    get '/signup'
    expect(last_response).to be_ok
  end

  it "displays login page if there is no user" do
    get '/topics', :user => nil

    expect(last_response.redirect?).to be_truthy
    follow_redirect!
    expect(last_request.path).to eq('/login')
  end

  it "should not register a new user with blank email" do
    post '/signup', params = {:user =>{'username' => 'testuser23',
                                       'email'  => '',
                                       'password'  => 'testpass',
                                       'password_confirmation' =>'testpass'}
    }
    follow_redirect!
    expect(last_response).to be_ok
    expect(last_response.body).to include("email    can't be blank")

  end

  it "should not register a new user with invalid password length" do
    post '/signup', params = {:user =>{'username' => 'testuser456',
                                       'email'  => 'e@example.com',
                                       'password'  => 'test',
                                       'password_confirmation' =>'test'}
    }
    follow_redirect!
    expect(last_response).to be_ok
    expect(last_response.body).
        to include('password    is too short (minimum is 6 characters)')

  end

  it "should register a new user" do
    post '/signup', params = {:user =>{'username' => 'Seconduser',
                                       'email'  => 'test@example.com',
                                       'password'  => 'testpass',
                                       'password_confirmation' =>'testpass'}
    }
    follow_redirect!
    expect(last_response).to be_ok
    expect(last_response.body).
        to include('Please confirm your email address to continue')

  end
  it "should not register a new user with existing username" do
    user1 = FactoryBot.create(:user)
    puts user1.username
    post '/signup',  params = {:user =>{'username' => 'Seconduser',
                                        'email'  => 'test@example.com',
                                        'password'  => 'testpass',
                                        'password_confirmation' =>'testpass'}
    }
    follow_redirect!
    expect(last_response).to be_ok
    expect(last_response.body).to include('username    has already been taken')

  end

  it "should allow accessing the login page" do
    get '/login'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Login')
  end

  it "should  login a user with valid data " do
    post '/login', params = {
                                       'email'  => 'test@example.com',
                                       'password'  => 'testpass'
    }
    follow_redirect!
    expect(last_response).to be_ok
    expect(last_response.body).to include('Successfully logged in')

  end

  it "blocks unauthenticated access" do
    user = FactoryBot.build_stubbed(:user)
    login_as user, scope: :default
    get '/topics'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Topics')

  end
end
