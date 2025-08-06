require_relative "tag_commands"
require_relative "../helpers/display_helper"
require "pry"

module CardCommands
  include TagCommands
  include DisplayHelper

  CARD_MENU_OPTIONS = [
    { name: "View tags for this card", value: :view_tags },
    { name: "Add/Remove tags to/from this card", value: :select_tags },
    { name: "Update/Delete a tag", value: :change_tag },
    { name: "Go back to card management menu", value: :go_back },
  ].freeze

  def view_cards
    results = load_cards
    display_cards_details(results) unless results.empty?
    manage_selected_deck
  end

  def manage_card
    manage_selected_card if load_and_display_card_choices
    manage_selected_deck
  end

  def create_card
    @action = "Create"
    create_new_card
    manage_selected_card
    manage_selected_deck
  end

  def update_card
    @action = "Update"
    update_selected_card if load_and_display_card_choices
    manage_selected_deck
  end

  def delete_card
    @action = "Delete"
    delete_selected_card if load_and_display_card_choices
    manage_selected_deck
  end

  private

  def load_and_display_card_choices
    results = load_cards
    display_card_choices(results) unless results.empty?
  end

  def display_card_choices(cards)
    card_choices = cards.map { |card| { name: card["front"], value: card["id"] } }
    card_choices << { name: "Back", value: :go_back }
    choice = @prompt.select("=== Select a Card to #{@action} ===",
                            card_choices, cycle: true)

    return false if choice == :go_back

    @card = cards.find { |card| card["id"] == choice }
  end

  def load_cards
    puts "📚 Loading cards for #{@deck['name']}..."
    result = @api_client.get_cards_by_deck(@deck["id"])

    if result_has_error?(result)
      handle_error(result)
      return []
    end

    show_no_cards_message if result.empty?

    result
  end

  def display_cards_details(cards)
    puts "\n=== Cards in #{@deck['name']}==="
    cards.each_with_index { |card, index| display_single_card(card, index) }
  end

  def display_single_card(card, index)
    puts "#{index + 1}. #{card['front']}"
    display_card_preview(card)
    display_card_tags(card)
  end

  def display_card_tags(card)
    puts "Tags: #{card_tag_display_message(card)}\n\n"
  end

  def card_tag_display_message(card)
    if card["tags"].length.positive?
      card["tags"].map do |tag|
        tag["name"]
      end.join(", ")
    else
      "No tags selected"
    end
  end

  def show_current_card_values(card)
    puts "\nCurrent values:"
    puts "Front: #{card['front']}"
    puts "Back: #{card['back']}"
  end

  def manage_selected_card
    return unless @card

    choice = @prompt.select("=== Select Tag Management Option for #{@card['front']} ===",
                            CARD_MENU_OPTIONS, cycle: true)

    send(choice) unless choice == :go_back
  end

  def show_no_cards_message
    @prompt.warn("📭 No cards found. Create your first card!")
    []
  end

  def no_cards_available?(cards_result)
    cards_result.key?("error") || cards_result.empty?
  end

  def create_new_card
    puts "\n=== Creating New Card... ==="
    front = prompt_user_for_required_string(string_name: "front", titleize: true)
    back = prompt_user_for_required_string(string_name: "back")
    result = @api_client.create_card(front: front, back: back, deck_id: @deck["id"])
    handle_card_result(result)
  end

  def update_selected_card
    puts "\n=== Update #{@card['front']}... ==="
    front = prompt_user_for_required_string(string_name: "front", value: @card["front"],
                                            titleize: true)
    back = prompt_user_for_required_string(string_name: "back",
                                           value: @card["back"])
    result = @api_client.update_card(@card["id"], front: front, back: back,
                                                  deck_id: @card["deck_id"])
    handle_card_result(result)
  end

  def delete_selected_card
    return unless @prompt.yes?("Would you like to delete card #{@card['front']}?") do |q|
      q.default true
      q.required true
    end

    result = @api_client.delete_card(@card["id"])
    handle_card_result(result)
  end

  def handle_card_result(result)
    if result.key?("error")
      @prompt.error("Failed to #{@action} card: #{result['error']}")
    elsif @action == "Delete"
      @prompt.ok("Card deleted successfully!")
      @card = nil
    else
      @prompt.ok("#{result['front']} #{@action}d successfully!")
      @card = result
    end
  end
end
