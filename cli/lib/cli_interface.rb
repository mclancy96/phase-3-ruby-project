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
    { name: "✌️ Exit", value: :exit },
  ].freeze

  def initialize
    @api_client = APIClient.new
    @prompt = TTY::Prompt.new(active_color: :cyan)
    setup_interrupt_handler
  end

  def run
    display_welcome
    main_loop
  rescue TTY::Reader::InputInterrupt, Interrupt
    puts "\n\n👋 Goodbye! Happy studying!"
  end

  def main_loop
    loop do
      choice = @prompt.select("=== Flash Card Manager Main Menu ===", MAIN_MENU_OPTIONS,
                              cycle: true)
      break puts "\n👋 Goodbye! Happy studying!" if choice == :exit

      with_interrupt_handling { send(choice) }
    end
  end

  private

  def setup_interrupt_handler
    Signal.trap("INT") do
      puts "\n\n👋 Goodbye! Happy studying!"
      exit(0)
    end
  end

  def with_interrupt_handling
    yield
  rescue TTY::Reader::InputInterrupt, Interrupt
    puts "\n🛑 Operation cancelled. Returning to main menu..."
    false
  end
end
