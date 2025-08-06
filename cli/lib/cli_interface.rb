require_relative "api_client"
require_relative "commands/deck_commands"
require_relative "helpers/display_helper"

class CLIInterface
  include DeckCommands
  include DisplayHelper

  MAIN_MENU_OPTIONS = [
    { name: "View details of all decks", value: :view_decks },
    { name: "Manage cards in a deck", value: :manage_deck },
    { name: "Create a new deck", value: :create_deck },
    { name: "Change a deck's name or description", value: :update_deck },
    { name: "Delete a deck", value: :delete_deck },
    { name: "Exit", value: :exit },
  ].freeze

  def initialize
    @api_client = APIClient.new
    @prompt = TTY::Prompt.new
  end

  def run
    display_welcome

    loop do
      choice = @prompt.select("=== Flash Card Manager Main Menu ===", MAIN_MENU_OPTIONS,
                              cycle: true)

      break puts "\n👋 Goodbye! Happy studying!" if choice == :exit

      send(choice)
    end
  end
end
