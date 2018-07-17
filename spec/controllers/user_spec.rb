
RSpec.describe Sinatra::App:: SignUp do
  include Rack::Test::Methods
  include Warden::Test::Helpers
  let(:user) { build :user }
  let(:admin)  { build :admin }
  def app
    @app = App
  end

  context 'with valid credentials' do
    it 'register a user, and send email' do
      post '/signup', params = { user:
                                    {
                                      username: 'username',
                                      email:  'example@craftacademy.se',
                                      password: 'password',
                                      password_confirmation: 'password'
                                    }
      }
      follow_redirect!
      expect(last_response).to be_ok
      expect(last_response.body).
          to include('Please confirm your email address to continue')
    end
  end

  context 'returns an error message when user submits' do
    it 'non-matching password confirmation' do
      post '/signup', params: { user:  {
          email: 'example@craftacademy.se', password: 'password',
          password_confirmation: 'wrong_password'
      }
      }
      expect(last_response.body).to eq ""

      expect(last_response.status).to eq 302
    end

    it 'a blank email' do
      post '/signup', params = { user:
                                     {
                                       username: 'username',
                                       email:  '',
                                       password: 'password',
                                       password_confirmation: 'password'
                                     }
      }
      follow_redirect!
      expect(last_response).to be_ok
      expect(last_response.body).to include("email    can't be blank")
      expect(last_response.status).to eq 200
    end

    it 'short password length' do
      post '/signup', params = { user:
                                     {
                                         username: 'example',
                                         email:  'adeleke@tests.com',
                                         password: 'test',
                                         password_confirmation: 'test'
                                     }
      }
      follow_redirect!
      expect(last_response).to be_ok
      expect(last_response.body)
        .to include('password    is too short (minimum is 6 characters)')

    end

    it 'an already registered username' do
      user = FactoryBot.create(:user)
      post '/signup', params = { user:
                                     {
                                         username: user.username,
                                         email:  user.email,
                                         password: user.password,
                                         password_confirmation: user.password_confirmation
                                     }
      }
      follow_redirect!
      expect(last_response).to be_ok
      expect(last_response.body).to include('Login')
      expect(last_response.body).to include('username    has already been taken')

    end

  end
end
