web: bundle exec rackup config.ru -p $PORT
#worker: bundle exec sidekiq -r ./app/app.rb
worker: bundle exec sidekiq  -e production  -r  ./app/app.rb
