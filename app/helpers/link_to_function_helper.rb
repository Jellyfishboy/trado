module LinkToFunctionHelper
    def link_to_function name, classes, *args, &block
        html_options = args.extract_options!.symbolize_keys

        function = block_given? ? update_page(&block) : args[0] || ''
        onclick = "#{"#{html_options[:onclick]}; " if html_options[:onclick]}#{function}; return false;"
        href = html_options[:href] || '#'

        content_tag(:a, html_options.merge(:href => href, :onclick => onclick, :class => classes)) do
            name.html_safe
        end
    end
end