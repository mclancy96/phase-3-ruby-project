require "rest-client"
require "json"

class APIClient
  attr_reader :base_url

  def initialize(base_url = "http://localhost:9292")
    @base_url = base_url
  end

  def decks
    make_request(:get, "/decks")
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

  def cards
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

  def tags
    make_request(:get, "/tags")
  end

  def get_tag_by_name(name)
    require "uri"
    encoded_name = URI.encode_www_form_component(name)
    make_request(:get, "/tags?name=#{encoded_name}")
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

  def add_card_tag(card_id:, tag_id:)
    make_request(:post, "/card_tags", { card_id: card_id, tag_id: tag_id })
  end

  def remove_card_tag(card_id:, tag_id:)
    make_request(:delete, "/card_tags", { card_id: card_id, tag_id: tag_id })
  end

  private

  def make_request(method, endpoint, params = {})
    url = "#{@base_url}#{endpoint}"
    response = execute_request(method, url, params)
    parse_response(response)
  rescue RestClient::Exception => e
    handle_api_error(e)
  rescue JSON::ParserError => e
    { "error" => "Invalid JSON response: #{e.message}" }
  end

  def execute_request(method, url, params)
    case method
    when :get
      RestClient.get(url)
    when :post
      RestClient.post(url, params.to_json, content_type: :json)
    when :patch
      RestClient.patch(url, params.to_json, content_type: :json)
    when :delete
      execute_delete_request(url, params)
    end
  end

  def execute_delete_request(url, params)
    if params.any?
      query_string = params.map { |key, value| "#{key}=#{value}" }.join("&")
      url = "#{url}?#{query_string}"
    end
    RestClient.delete(url)
  end

  def parse_response(response)
    return {} if response.body.nil? || response.body.strip.empty?

    JSON.parse(response.body)
  end

  def handle_api_error(error)
    case error.response&.code
    when 404
      { "error" => "Resource not found" }
    when 422
      handle_validation_error(error)
    when 500
      { "error" => "Server error" }
    else
      { "error" => "API request failed: #{error.message}" }
    end
  end

  def handle_validation_error(error)
    JSON.parse(error.response.body)
  rescue JSON::ParserError
    { "error" => "Validation error" }
  end
end
