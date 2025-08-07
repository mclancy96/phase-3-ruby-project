require_relative "base_commands"

module TagCommands
  include BaseCommands

  def view_tags
    display_card_tags(@card)
    manage_selected_card
  end

  def select_tags
    choose_tags_from_options
    manage_selected_card
  end

  def create_tag
    @action = "Create"
    create_new_tag
    manage_selected_card
  end

  def update_tag
    @action = "Update"
    @tag = load_and_display_choices("tag", :tags, @action)
    update_selected_tag if @tag
    manage_selected_card
  end

  def delete_tag
    @action = "Delete"
    @tag = load_and_display_choices("tag", :tags, @action)
    delete_selected_tag if @tag
    manage_selected_card
  end

  private

  def choose_tags_from_options
    all_tags = load_resources("tags", :tags)
    return if all_tags.empty?

    current_tag_names = @card["tags"].map { |tag| tag["name"] }
    choices = multi_select_prompt_with_tags(all_tags, current_tag_names)
    update_card_tags_based_on_selections(choices)
  end

  def multi_select_prompt_with_tags(all_tags, current_tag_names)
    @prompt.multi_select("Select tags for '#{@card['front']}':",
                         help: "\nPress spacebar to select options and enter to confirm",
                         show_help: :always, cycle: true) do |menu|
      menu.default(*current_tag_names) unless current_tag_names.empty?
      all_tags.each do |tag|
        menu.choice tag["name"], tag["id"]
      end
    end
  end

  def update_card_tags_based_on_selections(choices)
    current_tag_ids = @card["tags"].map { |tag| tag["id"] }
    tags_to_remove = current_tag_ids - choices
    remove_tags_from_card(tags_to_remove) unless tags_to_remove.empty?
    tags_to_add = choices - current_tag_ids
    add_tags_to_card(tags_to_add) unless tags_to_add.empty?
  end

  def remove_tags_from_card(tags_to_remove)
    tags_to_remove.each do |tag|
      result = @api_client.remove_card_tag(card_id: @card["id"].to_i, tag_id: tag)
      handle_tag_operation_result(result, "remove", tag)
    end
  end

  def add_tags_to_card(tags_to_add)
    tags_to_add.each do |tag|
      result = @api_client.add_card_tag(card_id: @card["id"].to_i, tag_id: tag)
      handle_tag_operation_result(result, "add", tag)
    end
  end

  def handle_tag_operation_result(result, operation, tag_id)
    if result.key?("error")
      @prompt.error("Failed to #{operation} tag #{tag_id}: #{result['error']}")
    else
      puts "#{operation == 'add' ? '+' : 'X'} #{operation.capitalize} tag ID #{tag_id}"
    end
  end

  def create_new_tag
    puts "\n=== Creating New Tag... ==="
    name = prompt_user_for_required_string(string_name: "name", titleize: true)
    if tag_name_already_exists?(name)
      @prompt.error("Tag with name #{name} already exists.")
      return
    end

    result = @api_client.create_tag(name: name)
    handle_tag_result(result)
  end

  def tag_name_already_exists?(name)
    !@api_client.get_tag_by_name(name).empty?
  end

  def update_selected_tag
    puts "\n=== Update #{@tag['name']}... ==="
    name = prompt_user_for_required_string(string_name: "name", value: @tag["name"],
                                           titleize: true)
    if tag_name_already_exists?(name)
      @prompt.error("Tag with name #{name} already exists.")
      return
    end

    result = @api_client.update_tag(@tag["id"], name: name)
    handle_tag_result(result)
  end

  def delete_selected_tag
    delete_resource("tag", :delete_tag, @tag["id"], @tag["name"])
  end

  def handle_tag_result(result)
    if result.key?("error")
      @prompt.error("Failed to #{@action} tag: #{result['error']}")
    elsif @action == "Delete"
      @prompt.ok("Tag deleted successfully!")
      @tag = nil
    else
      @prompt.ok("#{result['name']} #{@action}d successfully!")
      @tag = result
    end
  end
end
