require_relative "card_commands"
require_relative "../helpers/display_helper"
module DeckCommands
  include CardCommands
  include DisplayHelper

  DECK_MENU_OPTIONS = [
    { name: "View cards in this deck", value: :view_cards },
    { name: "Manage cards for this deck", value: :manage_card },
    { name: "Add a new card to this deck", value: :create_card },
    { name: "Change a card's front or back", value: :update_card },
    { name: "Delete a card", value: :delete_card },
    { name: "Go back to main menu", value: :go_back },
  ].freeze

  def view_decks
    results = load_decks

    puts "Results: #{results}, #{results.empty?}"

    display_decks_details(results) unless results.empty?
  end

  def manage_deck
    @action = "Manage"
    manage_selected_deck if load_and_display_deck_choices
  end

  def create_deck
    @action = "Create"
    create_new_deck
    @action = "Manage"
    manage_selected_deck
  end

  def update_deck
    @action = "Update"
    update_selected_deck if load_and_display_deck_choices
  end

  def delete_deck
    @action = "Delete"
    delete_selected_deck if load_and_display_deck_choices
  end

  private

  def load_and_display_deck_choices
    results = load_decks
    display_deck_choices(results) unless results.empty?
  end

  def display_deck_choices(decks)
    deck_choices = decks.map { |deck| { name: deck["name"], value: deck["id"] } }
    deck_choices << { name: "Back", value: :go_back }
    choice = @prompt.select("=== Select a Deck to #{@action} ===",
                            deck_choices, cycle: true)

    return false if choice == :go_back

    @deck = decks.find { |deck| deck["id"] == choice }
  end

  def load_decks
    puts "📚 Loading decks..."
    result = @api_client.get_decks

    return handle_error(result) if result_has_error?(result)

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

  def show_current_deck_values(deck)
    puts "\nCurrent values:"
    puts "Name: #{deck['name']}"
    puts "Description: #{deck['description'] || 'None'}"
  end

  def manage_selected_deck
    return unless @deck

    choice = @prompt.select("=== Select Card Management Option for #{@deck['name']} ===",
                            DECK_MENU_OPTIONS, cycle: true)

    send(choice) unless choice == :go_back
  end

  def result_has_error?(result)
    (result.is_a?(Hash) && result.key?("error")) || !result.is_a?(Array)
  end

  def handle_error(result)
    if result.is_a?(Hash) && result.key?("error")
      @prompt.error("Error: #{result['error']}")
    else
      @prompt.error("Unexpected response format")
    end
  end

  def show_no_decks_message
    @prompt.warn("📭 No decks found. Create your first deck!")
    []
  end

  def no_decks_available?(decks_result)
    decks_result.key?("error") || decks_result.empty?
  end

  def create_new_deck
    puts "\n=== Creating New Deck... ==="
    name = prompt_user_for_required_string(string_name: "name", titleize: true)
    description = prompt_user_for_required_string(string_name: "description")
    result = @api_client.create_deck(name: name, description: description)
    handle_deck_result(result)
  end

  def update_selected_deck
    puts "\n=== Update #{@deck['name']}... ==="
    name = prompt_user_for_required_string(string_name: "name", value: @deck["name"],
                                           titleize: true)
    description = prompt_user_for_required_string(string_name: "description",
                                                  value: @deck["description"])
    result = @api_client.update_deck(@deck["id"], name: name, description: description)
    handle_deck_result(result)
  end

  def delete_selected_deck
    return unless @prompt.yes?("Would you like to delete deck #{@deck['name']}?") do |q|
      q.default true
      q.required true
    end

    result = @api_client.delete_deck(@deck["id"])
    handle_deck_result(result)
  end

  def handle_deck_result(result)
    if result.key?("error")
      @prompt.error("Failed to #{@action} deck: #{result['error']}")
    elsif @action == "Delete"
      @prompt.ok("Deck deleted successfully!")
      @card = nil
    else
      @prompt.ok("#{result['name']} #{@action}d successfully!")
      @deck = result
    end
  end
end
