require "pry"
require_relative "card_commands"
module DeckCommands
  include CardCommands

  def view_decks
    results = load_decks

    display_decks_details(results)
  end

  def view_deck
    results = load_decks

    display_deck_choices(results)
  end

  private

  def display_deck_choices(decks)
    deck_choices = decks.map { |deck| { name: deck["name"], value: deck["id"] } }
    deck_choices << { name: "Back", value: :back }
    choice = @prompt.select("=== Flash Card Manager CLI ===", deck_choices, cycle: true)
    puts "You chose: #{choice}"
  end

  def load_decks
    puts "📚 Loading decks..."
    result = api_client.get_decks

    return handle_deck_error(result) if deck_result_has_error?(result)

    return show_no_decks_message if result.empty?

    result
  end

  def display_decks_details(decks)
    puts "\n=== Your Decks ==="
    decks.each_with_index { |deck, index| display_single_deck(deck, index) }
  end

  def display_single_deck(deck, index)
    puts "#{index + 1}. #{deck['name']}"
    display_deck_description(deck)
    display_deck_card_count(deck)
    puts
  end

  def display_deck_description(deck)
    description = deck["description"]
    puts "   Description: #{description}" if description && !description.empty?
  end

  def display_deck_card_count(deck)
    card_count = deck["cards"]&.length || 0
    puts "   #{card_count} cards"
  end

  def deck_result_has_error?(result)
    (result.is_a?(Hash) && result.key?("error")) || !result.is_a?(Array)
  end

  def handle_deck_error(result)
    if result.is_a?(Hash) && result.key?("error")
      prompt.error("Error: #{result['error']}")
    else
      prompt.error("Unexpected response format")
    end
  end

  def show_no_decks_message
    prompt.warn("📭 No decks found. Create your first deck!")
  end

  def no_decks_available?(decks_result)
    decks_result.key?("error") || decks_result.empty?
  end

  def show_current_deck_values(deck)
    puts "\nCurrent values:"
    puts "Name: #{deck['name']}"
    puts "Description: #{deck['description'] || 'None'}"
  end
end
