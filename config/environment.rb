# frozen_string_literal: true

# This is an _environment variable_ that is used by some of the Rake tasks to determine
# if our application is running locally in development, in a test environment, or in production
ENV["RACK_ENV"] ||= "development"

# Require in Gems
require "bundler/setup"
Bundler.require(:default, ENV.fetch("RACK_ENV", nil))

require "active_record"

# Set up database connection
ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "db/#{ENV.fetch('RACK_ENV', 'development')}.sqlite3"
)

# Require in all files in 'app' directory
require_all "app"
