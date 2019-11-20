class RoutesGeneratorHelper
  include Generatable

  def route_string
    GeneratorHelpers.mc_wrap_route_with_namespaces(namespace) do
      "resources :#{resource_name_plural}, only: [#{actions_str}]"
    end
  end

  private

  def actions_str
    controller_helper
      .actions
      .map { |attr| ":#{attr}" }
      .join(', ')
  end

  def namespace
    options[:'routes-namespace']
  end

  def controller_helper
    @controller_helper ||= ControllerGeneratorHelper.new(module_full_name, options)
  end
end
