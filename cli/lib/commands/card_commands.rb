require_relative "tag_commands"
require_relative "../helpers/display_helper"

module CardCommands
  include TagCommands
  include DisplayHelper

  CARD_MENU_OPTIONS = [
    { name: "View cards in this card", value: :view_cards },
    { name: "Manage tags for this card", value: :manage_card },
    { name: "Add a new card to this card", value: :create_card },
    { name: "Change a card's front or back", value: :update_card },
    { name: "Delete a card", value: :delete_card },
    { name: "Go back to main menu", value: :back },
  ].freeze

  def view_cards
    results = load_cards

    display_cards_details(results)
  end

  def manage_card
    manage_selected_card if load_and_display_card_choices
  end

  def create_card
    create_new_card
    manage_selected_card
  end

  def update_card
    @action = "Update"
    update_selected_card if load_and_display_card_choices
  end

  def delete_card
    @action = "Delete"
    delete_selected_card if load_and_display_card_choices
  end

  private

  def load_and_display_card_choices
    display_card_choices(load_cards)
  end

  def display_card_choices(cards)
    card_choices = cards.map { |card| { name: card["name"], value: card["id"] } }
    card_choices << { name: "Back", value: :back }
    choice = @prompt.select("=== Select a Card to #{@action} ===",
                            card_choices, cycle: true)

    return false if choice == :back

    @card = cards.find { |card| card["id"] == choice }
  end

  def load_cards
    puts "📚 Loading cards..."
    result = @api_client.get_cards

    return handle_card_error(result) if card_result_has_error?(result)

    return show_no_cards_message if result.empty?

    result
  end

  def display_cards_details(cards)
    puts "\n=== Your Cards ==="
    cards.each_with_index { |card, index| display_single_card(card, index) }
  end

  def display_single_card(card, index)
    puts "#{index + 1}. #{card['name']}"
    display_card_description(card)
    display_card_card_count(card)
    puts
  end

  def display_card_description(card)
    description = card["description"]
    puts "   Description: #{description}" if description && !description.empty?
  end

  def display_card_card_count(card)
    card_count = card["cards"]&.length || 0
    puts "   #{card_count} cards"
  end

  def show_current_card_values(card)
    puts "\nCurrent values:"
    puts "Name: #{card['name']}"
    puts "Description: #{card['description'] || 'None'}"
  end

  def manage_selected_card
    return unless @card

    choice = @prompt.select("=== Select Card Management Option for #{@card['name']} ===",
                            CARD_MENU_OPTIONS, cycle: true)

    send(choice) unless choice == :back
  end

  def card_result_has_error?(result)
    (result.is_a?(Hash) && result.key?("error")) || !result.is_a?(Array)
  end

  def handle_card_error(result)
    if result.is_a?(Hash) && result.key?("error")
      @prompt.error("Error: #{result['error']}")
    else
      @prompt.error("Unexpected response format")
    end
  end

  def show_no_cards_message
    @prompt.warn("📭 No cards found. Create your first card!")
  end

  def no_cards_available?(cards_result)
    cards_result.key?("error") || cards_result.empty?
  end

  def create_new_card
    puts "\n=== Creating New Card... ==="
    name = prompt_user_for_required_string(string_name: "name", titleize: true)
    description = prompt_user_for_required_string(string_name: "description")
    result = @api_client.create_card(name: name, description: description)
    handle_result(result)
  end

  def update_selected_card
    puts "\n=== Update #{@card['name']}... ==="
    name = prompt_user_for_required_string(string_name: "name", value: @card["name"],
                                           titleize: true)
    description = prompt_user_for_required_string(string_name: "description",
                                                  value: @card["description"])
    result = @api_client.update_card(@card["id"], name: name, description: description)
    handle_result(result)
  end

  def delete_selected_card
    return unless @prompt.yes?("Would you like to delete card #{@card['name']}?") do |q|
      q.default true
      q.required true
    end

    result = @api_client.delete_card(@card["id"])
    handle_result(result)
  end

  def handle_result(result)
    if result.key?("error")
      @prompt.error("Failed to #{@action} card: #{result['error']}")
    else
      @prompt.ok("#{result['name']} #{@action}d successfully!")
      @card = result
    end
  end
end
