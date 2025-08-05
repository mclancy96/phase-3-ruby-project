require_relative "api_client"
require_relative "commands/deck_commands"
require_relative "commands/card_commands"
require_relative "commands/tag_commands"
require_relative "helpers/display_helper"

class CLIInterface
  include DeckCommands
  include CardCommands
  include TagCommands
  include DisplayHelper

  MAIN_MENU_OPTIONS = [
    { name: "📚 View all decks", value: :view_decks },
    { name: "🃏 View all cards", value: :view_cards },
    { name: "🏷️  View all tags", value: :view_tags },
    { name: "➕ Create a new deck", value: :create_deck },
    { name: "➕ Create a new card", value: :create_card },
    { name: "➕ Create a new tag", value: :create_tag },
    { name: "✏️  Update a deck", value: :update_deck },
    { name: "✏️  Update a card", value: :update_card },
    { name: "🗑️  Delete a deck", value: :delete_deck },
    { name: "🗑️  Delete a card", value: :delete_card },
    { name: "📖 View cards by deck", value: :view_cards_by_deck },
    { name: "🔍 View cards by tag", value: :view_cards_by_tag },
    { name: "👋 Exit", value: :exit },
  ].freeze

  def initialize
    @api_client = APIClient.new
    @prompt = TTY::Prompt.new
  end

  def run
    display_welcome

    loop do
      choice = @prompt.select("=== Flash Card Manager CLI ===", MAIN_MENU_OPTIONS, cycle: true)

      case choice
      when :view_decks
        view_decks
      when :view_cards
        view_cards
      when :view_tags
        view_tags
      when :create_deck
        create_deck
      when :create_card
        create_card
      when :create_tag
        create_tag
      when :update_deck
        update_deck
      when :update_card
        update_card
      when :delete_deck
        delete_deck
      when :delete_card
        delete_card
      when :view_cards_by_deck
        view_cards_by_deck
      when :view_cards_by_tag
        view_cards_by_tag
      when :exit
        puts "\n👋 Goodbye! Happy studying!"
        break
      end

      pause_for_user
    end
  end
end
