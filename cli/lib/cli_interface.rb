require_relative "api_client"
require_relative "commands/deck_commands"
require_relative "commands/base_commands"
require_relative "helpers/display_helper"

class CLIInterface
  include DeckCommands
  include BaseCommands
  include DisplayHelper

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
      # Check if there are any decks available
      decks = @api_client.decks
      has_decks = decks.is_a?(Array) && !decks.empty?

      choice = @prompt.select("=== Flash Card Manager Main Menu ===",
                              main_menu_options(has_decks), cycle: true)
      break puts "\n👋 Goodbye! Happy studying!" if choice == :exit

      with_interrupt_handling { send(choice) }
    end
  end

  private

  def main_menu_options(has_decks = true)
    options = create_menu_options_with_conditional_disable(
      base_main_menu_options,
      has_decks,
      "(No decks available)",
      [:create_deck]
    )
    # Exit option should always be available
    options << { name: "✌️ Exit", value: :exit }
  end

  def base_main_menu_options
    [
      { name: "Select a deck to study", value: :study_deck },
      { name: "View details of all decks", value: :view_decks },
      { name: "Manage cards in a deck", value: :manage_deck },
      { name: "Change a deck's name or description", value: :update_deck },
      { name: "Delete a deck", value: :delete_deck },
      { name: "Create a new deck", value: :create_deck },
    ]
  end

  def setup_interrupt_handler
    Signal.trap("INT") do
      exit_gracefully
    end
  end

  def with_interrupt_handling
    yield
  rescue TTY::Reader::InputInterrupt, Interrupt
    exit_gracefully
  end

  def exit_gracefully
    puts "\n\n👋 Goodbye! Happy studying!"
    exit(0)
  end
end
