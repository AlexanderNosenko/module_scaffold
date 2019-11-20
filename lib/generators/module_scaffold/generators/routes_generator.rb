class RoutesGenerator
  include Generatable

  def route_string
    TemplateHelpers.mc_wrap_route_with_namespaces(namespace) do
      "resources :#{resource_name_plural}, only: [#{actions_str}]"
    end
  end

  def generate_files(routes_processor:, **)
    routes_processor.call(route_string)
  end

  private

  def actions_str
    controller_generator
      .actions
      .map { |attr| ":#{attr}" }
      .join(', ')
  end

  def namespace
    options[:'routes-namespace']
  end

  def controller_generator
    @controller_generator ||= ControllerGenerator.new(module_full_name, options)
  end
end
