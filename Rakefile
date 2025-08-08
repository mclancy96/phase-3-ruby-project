# frozen_string_literal: true

require_relative "config/environment"
require "sinatra/activerecord/rake"

desc "Start the server"
task :server do
  ENV["PORT"] ||= "9292"
  rackup = "./bin/rackup -p #{ENV.fetch('PORT', nil)}"

  exec "bundle exec rerun -b '#{rackup}'"
end

desc "Start the console"
task :console do
  ActiveRecord::Base.logger = Logger.new($stdout)
  Pry.start
end
