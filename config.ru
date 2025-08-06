# frozen_string_literal: true

require_relative "config/environment"

# Allow CORS (Cross-Origin Resource Sharing) requests
use Rack::Cors do
  allow do
    origins "*"
    resource "*", headers: :any, methods: %i[get post delete put patch options head]
  end
end

use Rack::JSONBodyParser

use DecksController
use CardsController
use CardTagsController
use TagsController
run ApplicationController
