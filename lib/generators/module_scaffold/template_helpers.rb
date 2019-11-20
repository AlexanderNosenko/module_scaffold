module TemplateHelpers
  private

  def mc_wrap_with_namespaces(namespace, &context_block)
    content = yield context_block
    content = indent(content.strip).chomp

    modules = Generatable.namespace_modules(namespace)
    return content if modules.size.zero?

    modules.each_with_index.reduce('placeholder') do |acc, (namespace_part, index)|
      maybe_content = if (index + 1) == modules.size
        content
      else
        'placeholder'
      end

      if content != 'placeholder'
        # content = "\n#{content}\n"
        # content = indent(content)
      end

      module_definition = "module #{namespace_part}\n#{maybe_content}\nend"
      module_definition = indent(module_definition) unless index.zero?

      acc.gsub!('placeholder', module_definition)
    end.strip
  end

  def mc_wrap_route_with_namespaces(namespace, &context_block)
    content = yield context_block
    content = content.strip.chomp.indent(2)

    modules = Generatable.namespace_modules(namespace)
    return content if modules.size.zero?

    modules.each_with_index.reduce('placeholder') do |acc, (namespace_part, index)|
      maybe_content = if (index + 1) == modules.size
        content
      else
        'placeholder'
      end

      if content != 'placeholder'
        # content = "\n#{content}\n"
        # content = indent(content)
      end

      module_definition = "namespace :#{namespace_part.underscore} do \n#{maybe_content}\nend"
      module_definition = module_definition.indent(2) unless index.zero?

      acc.gsub!('placeholder', module_definition)
    end.strip + "\n"
  end

  module_function :mc_wrap_route_with_namespaces
end
