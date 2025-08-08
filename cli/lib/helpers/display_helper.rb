require "tty-spinner"

module DisplayHelper
  def display_welcome
    puts big_brain_time
    puts "Welcome to Flash Card Manager CLI, #{ENV['USER'].split('.').map(&:capitalize).join(' ')}!"
    puts "This app helps you manage your flash cards to maximize your learning."
    puts "This application connects to your Sinatra API."
    puts "Make sure your API server is running on http://localhost:9292"
    puts "Use ↑/↓ arrow keys to navigate and ENTER to select.\n\n"
  end

  def display_card_preview(card, pause: false)
    print_flash_card_side(card, "front")
    if pause
      prompt_and_flip(card, "Press space or enter to see back of card")
      prompt_and_flip(card, "Press space or enter to continue to next card")
      clear_screen
    else
      print_flash_card_side(card, "back")
    end
  end

  def prompt_and_flip(card, text)
    spinning_prompt(text)
    animate_card_flip(card)
  end

  def spinning_prompt(text)
    spinning_frames = ["", ".", "..", "...", "....", ".....", "     "]
    spinner = TTY::Spinner.new("#{text} :spinner", frames: spinning_frames, clear: true,
                                                   interval: 6, hide_cursor: true)
    with_interrupt_handling do
      spinner.auto_spin
      @prompt.keypress("", keys: %i[space return])
    end

    spinner.stop
  end

  def prompt_user_for_required_string(string_name:, value: "", titleize: false)
    result = with_interrupt_handling do
      @prompt.ask("Enter #{string_name}:") do |q|
        q.modify :strip
        q.required true
        q.value value
      end
    end

    return false if result == false

    titleize ? result.split.map(&:capitalize).join(" ") : result
  end

  private

  def animate_card_flip(card)
    clear_screen
    show_three_frame_flip(card)
    puts "FRONT: #{card['front']}"
    print_flash_card_side(card, "back")
  end

  def clear_screen
    system("clear") || system("cls")
  end

  def show_three_frame_flip(card)
    show_frame_and_sleep(print_tilting_frame(card["front"]))
    show_frame_and_sleep(print_edge_on_frame)
    show_frame_and_sleep(print_tilting_frame(card["back"]))
    clear_screen
  end

  def show_frame_and_sleep(frame)
    puts(frame)
    sleep(0.2)
    clear_screen
  end

  def print_tilting_frame(text)
    puts "      ┌─────────────────────────┐"
    puts "      │\\                       /│"
    puts "      │ \\      #{(text.slice(0, 10) || '').center(10)}     / │"
    puts "      │  \\     #{(text.slice(11, 10) || '').center(10)}    /  │"
    puts "      └─────────────────────────┘"
  end

  def print_edge_on_frame
    puts "                    │"
    puts "                    │"
    puts "                    │"

  end

  def print_flash_card_side(card, side_name)
    lines = wrap_text(card[side_name])
    print_top(side_name.upcase)
    print_lines(lines)
    print_bottom_border
  end

  def wrap_text(text, width = 35)
    return [] if text.nil? || text.empty?

    words = text.split(/\s+/)
    lines = []
    current_line = ""

    words.each do |word|
      current_line = measure_and_build_line(current_line, word, width, lines)
    end

    lines << current_line unless current_line.empty?
    lines
  end

  def measure_and_build_line(current_line, word, width, lines)
    if line_too_long?(current_line, word, width) && !current_line.empty?
      lines << current_line
      word
    else
      build_line(current_line, word)
    end
  end

  def line_too_long?(current_line, word, width)
    "#{current_line} #{word}".length > width
  end

  def build_line(current_line, word)
    current_line.empty? ? word : "#{current_line} #{word}"
  end

  def print_lines(lines, width = 35)
    if lines.empty?
      puts "│                                     │"
    else
      lines.each do |line|
        print_ljust_line(line, width)
      end
    end
  end

  def print_top(section_name, width = 35)
    print_top_border
    print_ljust_line(section_name, width)
  end

  def print_ljust_line(print_string, width)
    puts "│ #{print_string.ljust(width)} │"
  end

  def print_top_border
    puts "┌─────────────────────────────────────┐"
  end

  def print_bottom_border
    puts "└─────────────────────────────────────┘"
  end

  def big_brain_time # rubocop:disable Metrics/MethodLength
    "┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                                                                                                                                 │
│                                                                                                                                                                 │
│                                                                                                                                                                 │
│   oooooooooo.  ooooo   .oooooo.         oooooooooo.  ooooooooo.         .o.       ooooo ooooo      ooo      ooooooooooooo ooooo ooo        ooooo oooooooooooo   │
│   `888'   `Y8b `888'  d8P'  `Y8b        `888'   `Y8b `888   `Y88.      .888.      `888' `888b.     `8'      8'   888   `8 `888' `88.       .888' `888'     `8   │
│    888     888  888  888                 888     888  888   .d88'     .8.888.      888   8 `88b.    8            888       888   888b     d'888   888           │
│    888oooo888'  888  888                 888oooo888'  888ooo88P'     .8' `888.     888   8   `88b.  8            888       888   8 Y88. .P  888   888oooo8      │
│    888    `88b  888  888     ooooo       888    `88b  888`88b.      .88ooo8888.    888   8     `88b.8            888       888   8  `888'   888   888           │
│    888    .88P  888  `88.    .88'        888    .88P  888  `88b.   .8'     `888.   888   8       `888            888       888   8    Y     888   888       o   │
│   o888bood8P'  o888o  `Y8bood8P'        o888bood8P'  o888o  o888o o88o     o8888o o888o o8o        `8           o888o     o888o o8o        o888o o888ooooood8   │
│                                                                                                                                                                 │
│                                                                                                                                                                 │
│                                                                                                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘

".freeze
  end
end
