require_relative "../helpers/display_helper"

module TagCommands
  include DisplayHelper

  # TAG_MENU_OPTIONS = [
  #   { name: "View tags for this tag", value: :view_tags },
  #   { name: "Add tags to this tag", value: :add_tags },
  #   { name: "Remove a tag from this tag", value: :remove_tag },
  #   { name: "Update/Delete a tag", value: :change_tag },
  #   { name: "Go back to tag management menu", value: :go_back },
  # ].freeze

  def view_tags
    display_card_tags(@card)
    manage_selected_card
  end

  def select_tags

  end

  def change_tag

  end

  private

  def create_tag
    @action = "Create"
    create_new_tag
    manage_selected_tag
    manage_selected_card
  end

  def update_tag
    @action = "Update"
    update_selected_tag if load_and_display_tag_choices
    manage_selected_card
  end

  def delete_tag
    @action = "Delete"
    delete_selected_tag if load_and_display_tag_choices
    manage_selected_card
  end


  # def load_and_display_tag_choices
  #   results = load_tags
  #   display_tag_choices(results) unless results.empty?
  # end

  # def display_tag_choices(tags)
  #   tag_choices = tags.map { |tag| { name: tag["front"], value: tag["id"] } }
  #   tag_choices << { name: "Back", value: :go_back }
  #   choice = @prompt.select("=== Select a Tag to #{@action} ===",
  #                           tag_choices, cycle: true)

  #   return false if choice == :go_back

  #   @tag = tags.find { |tag| tag["id"] == choice }
  # end

  # def load_tags
  #   puts "📚 Loading tags for #{@card['name']}..."
  #   result = @api_client.get_tags_by_card(@card["id"])

  #   if tag_result_has_error?(result)
  #     handle_tag_error(result)
  #     return []
  #   end

  #   show_no_tags_message if result.empty?

  #   result
  # end

  # def display_single_tag(tag, index)
  #   puts "#{index + 1}. #{tag['front']}"
  #   display_tag_preview(tag)
  #   display_tag_tags(tag)
  # end

  # def display_tag_tags(tag)
  #   puts "Tags: #{tag_tag_display_message(tag)}\n\n"
  # end

  # def tag_display_message(tags)
  #   if tags.length.positive?
  #     tags.map do |tag|
  #       tag["name"]
  #     end.join(", ")
  #   else
  #     "No tags selected"
  #   end
  # end

  # def show_current_tag_values(tag)
  #   puts "\nCurrent values:"
  #   puts "Front: #{tag['front']}"
  #   puts "Back: #{tag['back']}"
  # end

  # def manage_selected_tag
  #   return unless @tag

  #   choice = @prompt.select("=== Select Tag Management Option for #{@tag['front']} ===",
  #                           TAG_MENU_OPTIONS, cycle: true)

  #   send(choice) unless choice == :go_back
  # end

  # def tag_result_has_error?(result)
  #   (result.is_a?(Hash) && result.key?("error")) || !result.is_a?(Array)
  # end

  # def handle_tag_error(result)
  #   if result.is_a?(Hash) && result.key?("error")
  #     @prompt.error("Error: #{result['error']}")
  #   else
  #     @prompt.error("Unexpected response format")
  #   end
  # end

  # def show_no_tags_message
  #   @prompt.warn("No tags found. Add tags to this card!")
  #   []
  # end

  # def no_tags_available?(tags_result)
  #   tags_result.key?("error") || tags_result.empty?
  # end

  # def create_new_tag
  #   puts "\n=== Creating New Tag... ==="
  #   front = prompt_user_for_required_string(string_name: "front", titleize: true)
  #   back = prompt_user_for_required_string(string_name: "back")
  #   result = @api_client.create_tag(front: front, back: back, card_id: @card["id"])
  #   handle_tag_result(result)
  # end

  # def update_selected_tag
  #   puts "\n=== Update #{@tag['front']}... ==="
  #   front = prompt_user_for_required_string(string_name: "front", value: @tag["front"],
  #                                           titleize: true)
  #   back = prompt_user_for_required_string(string_name: "back",
  #                                          value: @tag["back"])
  #   result = @api_client.update_tag(@tag["id"], front: front, back: back,
  #                                               card_id: @tag["card_id"])
  #   handle_tag_result(result)
  # end

  # def delete_selected_tag
  #   return unless @prompt.yes?("Would you like to delete tag #{@tag['front']}?") do |q|
  #     q.default true
  #     q.required true
  #   end

  #   result = @api_client.delete_tag(@tag["id"])
  #   handle_tag_result(result)
  # end

  # def handle_tag_result(result)
  #   if result.key?("error")
  #     @prompt.error("Failed to #{@action} tag: #{result['error']}")
  #   elsif @action == "Delete"
  #     @prompt.ok("Tag deleted successfully!")
  #     @tag = nil
  #   else
  #     @prompt.ok("#{result['front']} #{@action}d successfully!")
  #     @tag = result
  #   end
  # end
end
