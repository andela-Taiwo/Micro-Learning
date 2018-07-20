
RSpec.describe Sinatra::App:: ResourceController do
  include Rack::Test::Methods
  include Warden::Test::Helpers

  after { Warden.test_reset! }
  let(:user) { build :user }
  let(:topic) {create :topic }
  let(:resource) {create :resource }
  describe 'Admin  resources' do
    before { login_as FactoryBot.create(:admin, username: 'testadmin12') }
    def app
      @app = App
    end
    context 'with valid credentials' do

      it 'admin views resources' do
        get '/admin/resource'
        expect(last_response).to be_ok

        expect(last_response.body).to include('Resources')
      end

      it 'add new the resource' do
        post '/admin/resource', params = { resource:
                                               {
                                                   title: 'Introduction to JS',
                                                   description:  'The gentle introduction
      to learning javascript',
                                                   url: 'http://mdn.com/learnjs'
                                               }
        }
        follow_redirect!
        expect(last_response).to be_ok
        expect(last_response.body).to include('Successfully add a new resource')
      end

      it 'edit the resource ' do
        patch "/admin/resource/#{resource.id}/edit", params = { resource:
                                            {
                                                title: 'JS introduction book'

                                            }
        }
        follow_redirect!
        expect(last_response).to be_ok
        expect(last_response.body).to include('Successfully updated the resource')
      end

      it 'delete a resource ' do
        delete "/admin/resource/#{resource.id}/delete"
        follow_redirect!
        expect(last_response).to be_ok
        expect(last_response.body).to include('Successfully deleted the resource')
      end
    end

    context 'with invalid data set' do
      it 'should not add new the resource when title is blank' do
        post '/admin/resource', params = { topic:
                                            {
                                                title: '',
                                                description:  'The gentle introduction
      to learning javascript'
                                            }
        }
        follow_redirect!
        expect(last_response).to be_ok
        expect(last_response.body).to include('title    is too short (minimum is 6 characters')
      end

      it 'should not add new the resource when description is blank' do
        post '/admin/resource', params = { resource:
                                            {
                                                title: 'The beginning of new course',
                                                description: ' '
                                            }
        }
        follow_redirect!
        expect(last_response).to be_ok
        expect(last_response.body)
          .to include('description    is too short (minimum is 10 characters)')
      end

      it 'when blank title is provided, resource title should remain unchange ' do
        patch "/admin/resource/#{resource.id}/edit", params = { resource:
                                                              {
                                                                  title: ''
                                                              }
        }
        follow_redirect!
        expect(last_response).to be_ok
        expect(last_response.body).to include(resource.title)
      end

      it 'can delete non existing resource ' do
        delete "/admin/resource/#{5}/delete"
        follow_redirect!
        expect(last_response).to be_ok
        expect(last_response.body).to include('Unable to delete the resource')
      end
    end
  end

end
