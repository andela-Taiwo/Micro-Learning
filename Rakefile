require './app/app'
require 'sinatra/activerecord/rake'

require 'coveralls/rake/task'

Coveralls::RakeTask.new
task :test_with_coveralls => [:spec, :features, 'coveralls:push']
# Rake::TestTask.new do |task|
#   task.test_files = FileList['spec/**/*_spec.rb']
# end
#
# task default: :test