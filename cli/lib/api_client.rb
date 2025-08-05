require "rest-client"
require "json"

class APIClient
  attr_reader :base_url

  def initialize(base_url = "http://localhost:9292")
    @base_url = base_url
  end

  # Deck API methods
  def get_decks
    make_request(:get, "/decks")
  end

  def get_deck(id)
    response = make_request(:get, "/decks/#{id}")
    return response if response.key?("error")

    Deck.new(response)
  end

  def create_deck(name:, description:)
    make_request(:post, "/decks", { name: name, description: description })
  end

  def update_deck(id, name: nil, description: nil)
    params = {}
    params[:name] = name if name
    params[:description] = description if description
    make_request(:patch, "/decks/#{id}", params)
  end

  def delete_deck(id)
    make_request(:delete, "/decks/#{id}")
  end

  # Card API methods
  def get_cards
    make_request(:get, "/cards")
  end

  def get_card(id)
    make_request(:get, "/cards/#{id}")
  end

  def create_card(front:, back:, deck_id:)
    make_request(:post, "/cards", { front: front, back: back, deck_id: deck_id })
  end

  def update_card(id, front: nil, back: nil, deck_id: nil)
    params = {}
    params[:front] = front if front
    params[:back] = back if back
    params[:deck_id] = deck_id if deck_id
    make_request(:patch, "/cards/#{id}", params)
  end

  def delete_card(id)
    make_request(:delete, "/cards/#{id}")
  end

  def get_cards_by_deck(deck_id)
    make_request(:get, "/decks/#{deck_id}/cards")
  end

  # Tag API methods
  def get_tags
    make_request(:get, "/tags")
  end

  def get_tag(id)
    make_request(:get, "/tags/#{id}")
  end

  def create_tag(name:)
    make_request(:post, "/tags", { name: name })
  end

  def update_tag(id, name:)
    make_request(:patch, "/tags/#{id}", { name: name })
  end

  def delete_tag(id)
    make_request(:delete, "/tags/#{id}")
  end

  def get_cards_by_tag(tag_id)
    make_request(:get, "/tags/#{tag_id}/cards")
  end

  private

  def make_request(method, endpoint, params = {})
    url = "#{@base_url}#{endpoint}"

    case method
    when :get
      response = RestClient.get(url)
    when :post
      response = RestClient.post(url, params.to_json, content_type: :json)
    when :patch
      response = RestClient.patch(url, params.to_json, content_type: :json)
    when :delete
      response = RestClient.delete(url)
    end

    JSON.parse(response.body)
  rescue RestClient::Exception => e
    handle_api_error(e)
  rescue JSON::ParserError => e
    { error: "Invalid JSON response: #{e.message}" }
  end

  def handle_api_error(error)
    case error.response&.code
    when 404
      { error: "Resource not found" }
    when 422
      begin
        JSON.parse(error.response.body)
      rescue JSON::ParserError
        { error: "Validation error" }
      end
    when 500
      { error: "Server error" }
    else
      { error: "API request failed: #{error.message}" }
    end
  end
end
