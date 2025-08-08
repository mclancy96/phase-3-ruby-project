require_relative "base_commands"
require_relative "tag_commands"

module CardCommands
  include BaseCommands
  include TagCommands

  def view_cards
    results = load_resources("cards for #{@deck['name']}", :get_cards_by_deck, @deck["id"])
    display_cards_details(results) unless results.empty?
    manage_selected_deck
  end

  def manage_card
    @card = load_and_display_choices("card", :get_cards_by_deck, "Manage",
                                     { name_field: "front", id_field: "id",
                                       api_args: [@deck["id"]], })
    manage_selected_card if @card
    manage_selected_deck
  end

  def create_card
    @action = "Create"
    create_resource("card", :create_card, {
                      front: { titleize: true },
                      back: {},
                      deck_id: { value: @deck["id"] },
                    })
    refresh_deck_data if @card
    manage_selected_card if @card
    manage_selected_deck
  end

  def update_card
    @action = "Update"
    @card = select_card_for_action(@action)
    perform_card_update if @card
    refresh_deck_data if @card
    manage_selected_deck
  end

  def delete_card
    @action = "Delete"
    @card = select_card_for_action(@action)
    if @card
      delete_resource("card", :delete_card, @card["id"], @card["front"])
      refresh_deck_data unless @card
    end
    manage_selected_deck
  end

  private

  def select_card_for_action(action)
    load_and_display_choices("card", :get_cards_by_deck, action,
                             { name_field: "front", id_field: "id",
                               api_args: [@deck["id"]], })
  end

  def perform_card_update
    update_resource("card", :update_card, @card["id"], {
                      front: { titleize: true },
                      back: {},
                      deck_id: { value: @card["deck_id"] },
                    }, @card)
  end

  def display_cards_details(cards)
    puts "\n=== Deck #{@deck['name']} > Cards in #{@deck['name']}==="
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

  def manage_selected_card
    return unless @card

    refresh_card_data
    tags = @api_client.tags
    has_tags = tags.is_a?(Array) && !tags.empty?

    choice = @prompt.select("=== Deck #{@deck['name']} > Card > Select Tag Management Option for #{@card['front']} ===",
                            card_menu_options(has_tags), cycle: true)

    send(choice) unless choice == :go_back
  end

  def card_menu_options(has_tags = true)
    options = create_menu_options_with_conditional_disable(
      base_card_menu_options,
      has_tags,
      "(No tags available)",
      [:create_tag]
    )
    add_back_option(options, "Go back to card management menu")
  end

  def base_card_menu_options
    [
      { name: "View tags for this card", value: :view_tags },
      { name: "Add/Remove tags to/from this card", value: :select_tags },
      { name: "Create a new tag", value: :create_tag },
      { name: "Change the name of an existing tag", value: :update_tag },
      { name: "Delete a tag", value: :delete_tag },
    ]
  end

  def refresh_card_data
    refresh_resource_data("card", :get_card, @card["id"])
  end

  def refresh_deck_data
    decks = @api_client.decks
    return unless decks.is_a?(Array) && !decks.empty?

    updated_deck = decks.find { |deck| deck["id"] == @deck["id"] }
    @deck = updated_deck if updated_deck

  end
end
