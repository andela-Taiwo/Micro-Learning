require "./app/app"
require "coveralls/rake/task"
require "rake"
require "rspec/core/rake_task"
require "rubygems"
require "sinatra/activerecord/rake"

desc "Run RSpec"

RSpec::Core::RakeTask.new do |t|
  t.verbose = false
end
task default: :spec
Coveralls::RakeTask.new
