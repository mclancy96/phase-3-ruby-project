require_relative "../helpers/display_helper"

module BaseCommands
  include DisplayHelper

  private

  def load_resources(resource_type, api_method, *args)
    puts "Loading #{resource_type}..."
    result = @api_client.send(api_method, *args)
    return handle_load_error(result) if result_has_error?(result)
    return handle_empty_result(resource_type) if result.empty?

    result
  end

  def handle_load_error(result)
    handle_error(result)
    []
  end

  def handle_empty_result(resource_type)
    show_no_resources_message(resource_type)
    []
  end

  def display_choices_and_select(resources, resource_type, action, name_field = "name",
                                 id_field = "id")
    choices = create_choices_from_resources(resources, name_field, id_field)
    choices <<= { name: "⬅ Back", value: :go_back }

    choice = with_interrupt_handling do
      @prompt.select("=== Select a #{resource_type.capitalize} to #{action} ===",
                     choices, cycle: true)
    end

    return false if [:go_back, false].include?(choice)

    resources.find { |resource| resource[id_field] == choice }
  end

  def create_choices_from_resources(resources, name_field, id_field)
    sorted_resources = resources.sort_by do |resource|
      resource[name_field]
    end
    sorted_resources.map do |resource|
      { name: resource[name_field], value: resource[id_field] }
    end
  end

  def load_and_display_choices(resource_type, api_method, action, options = {})
    name_field = options[:name_field] || "name"
    id_field = options[:id_field] || "id"
    api_args = options[:api_args] || []

    resources = load_resources(resource_type, api_method, *api_args)
    return false if resources.empty?

    display_choices_and_select(resources, resource_type, action, name_field, id_field)
  end

  def handle_resource_result(result, resource_type, action, name_field = "name")
    name_field = "front" if resource_type == "card"

    if result.key?("error")
      @prompt.error("Failed to #{action} #{resource_type}: #{result['error']}")
    elsif action == "Delete"
      @prompt.ok("#{resource_type.capitalize} deleted successfully!")
      clear_resource_variable(resource_type)
    else
      @prompt.ok("#{result[name_field]} #{action}d successfully!")
      set_resource_variable(resource_type, result)
    end
  end

  def create_resource(resource_type, api_method, fields)
    puts "\n=== Creating New #{resource_type.capitalize}... ==="
    params = build_create_params(fields)
    return if params.nil? # User cancelled operation

    result = @api_client.send(api_method, **params)
    handle_resource_result(result, resource_type, "Create")
  end

  def build_create_params(fields)
    params = {}
    fields.each do |field, options|
      value = get_field_value_for_create(field, options)
      return nil if value == false

      params[field] = value
    end
    params
  end

  def update_resource(resource_type, api_method, resource_id, fields, current_resource)
    name_field = resource_type == "card" ? "front" : fields.keys.first.to_s
    puts "\n=== Update #{current_resource[name_field]}... ==="
    params = build_update_params(fields, current_resource)
    return if params.nil? # User cancelled operation

    result = @api_client.send(api_method, resource_id, **params)
    handle_resource_result(result, resource_type, "Update")
  end

  def build_update_params(fields, current_resource)
    params = {}
    fields.each do |field, options|
      value = get_field_value_for_update(field, options, current_resource)
      return nil if value == false

      params[field] = value
    end
    params
  end

  def delete_resource(resource_type, api_method, resource_id, resource_name)
    confirmed = with_interrupt_handling do
      @prompt.yes?("Would you like to delete #{resource_type} #{resource_name}?") do |q|
        q.default true
        q.required true
      end
    end

    return unless confirmed

    result = @api_client.send(api_method, resource_id)
    handle_resource_result(result, resource_type, "Delete")
  end

  def result_has_error?(result)
    (result.is_a?(Hash) && result.key?("error")) || !result.is_a?(Array)
  end

  def handle_error(result)
    if result.is_a?(Hash) && result.key?("error")
      @prompt.error("Error: #{result['error']}")
    else
      @prompt.error("Unexpected response format")
    end
  end

  def show_no_resources_message(resource_type)
    @prompt.warn("No #{resource_type} found. Create your first #{resource_type}!")
  end

  def set_resource_variable(resource_type, value)
    instance_variable_set("@#{resource_type}", value)
  end

  def clear_resource_variable(resource_type)
    instance_variable_set("@#{resource_type}", nil)
  end

  def get_resource_variable(resource_type)
    instance_variable_get("@#{resource_type}")
  end

  def get_field_value_for_create(field, options)
    options ||= {}
    options[:value] || prompt_user_for_required_string(
      string_name: field.to_s,
      titleize: options[:titleize] || false
    )
  end

  def get_field_value_for_update(field, options, current_resource)
    options ||= {}
    options[:value] || prompt_user_for_required_string(
      string_name: field.to_s,
      value: current_resource[field.to_s],
      titleize: options[:titleize] || false
    )
  end

  def refresh_resource_data(resource_type, api_method, resource_id)
    updated_resource = @api_client.send(api_method, resource_id)

    if updated_resource && !updated_resource.key?("error")
      set_resource_variable(resource_type, updated_resource)
      updated_resource
    else
      @prompt.error("Failed to refresh #{resource_type} data: #{if updated_resource
                                                                  updated_resource['error']
                                                                end}")
      nil
    end
  end

  def create_menu_options_with_conditional_disable(base_options, condition, disabled_message,
                                                   always_enabled = [])
    options = base_options.dup

    unless condition
      options.each do |option|
        option[:disabled] = disabled_message unless always_enabled.include?(option[:value])
      end
    end

    options
  end

  def add_back_option(options, back_text = "⬅ Go back")
    options << { name: back_text, value: :go_back }
  end
end
