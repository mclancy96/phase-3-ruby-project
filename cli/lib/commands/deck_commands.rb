require_relative "base_commands"
require_relative "card_commands"

module DeckCommands
  include BaseCommands
  include CardCommands

  def view_decks
    results = load_resources("decks", :decks)
    display_decks_details(results) unless results.empty?
  end

  def manage_deck
    @action = "Manage"
    @deck = load_and_display_choices("deck", :decks, @action)
    manage_selected_deck if @deck
  end

  def create_deck
    @action = "Create"
    create_resource("deck", :create_deck, {
                      name: { titleize: true },
                      description: {},
                    })
    @action = "Manage"
    manage_selected_deck if @deck
  end

  def update_deck
    @action = "Update"
    @deck = load_and_display_choices("deck", :decks, @action)
    return unless @deck

    update_resource("deck", :update_deck, @deck["id"], {
                      name: { titleize: true },
                      description: {},
                    }, @deck)

  end

  def delete_deck
    @action = "Delete"
    @deck = load_and_display_choices("deck", :decks, @action)
    delete_resource("deck", :delete_deck, @deck["id"], @deck["name"]) if @deck
  end

  def study_deck
    @action = "Study"
    result = load_and_display_choices("deck", :decks, @action)
    return unless result

    @deck = result
    validate_deck_and_loop_cards
  end

  private

  def validate_deck_and_loop_cards
    return puts "No cards in this deck" unless selected_deck_has_cards?

    loop_through_cards_in_deck
  end

  def loop_through_cards_in_deck
    @deck["cards"].each { |card| display_card_preview(card, pause: true) }
  end

  def deck_menu_options(has_cards = true)
    options = create_menu_options_with_conditional_disable(
      base_deck_menu_options,
      has_cards,
      "(No cards in this deck)",
      [:create_card]
    )
    add_back_option(options, "⬅ Go back to main menu")
  end

  def base_deck_menu_options
    [
      { name: "View cards in this deck", value: :view_cards },
      { name: "Manage a card's tags", value: :manage_card },
      { name: "Add a new card to this deck", value: :create_card },
      { name: "Change a card's front or back", value: :update_card },
      { name: "Delete a card", value: :delete_card },
    ]
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

  def manage_selected_deck
    return unless @deck

    choice = @prompt.select("=== Deck > Select Card Management Option for #{@deck['name']} ===",
                            deck_menu_options(selected_deck_has_cards?), cycle: true)

    send(choice) unless choice == :go_back
  end

  def selected_deck_has_cards?
    @deck && @deck["cards"]&.any?
  end
end
