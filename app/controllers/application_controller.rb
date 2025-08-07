# frozen_string_literal: true

class ApplicationController < Sinatra::Base
  set :default_content_type, "application/json"

  configure do
    enable :cross_origin
  end

  not_found do
    { error: "Route not found" }.to_json
  end

  error do
    { error: "Internal server error" }.to_json
  end
end
