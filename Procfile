web: bundle exec rackup config.ru -p $PORT
worker: bundle exec sidekiq -r ./app/app.rb -c 5 -v
