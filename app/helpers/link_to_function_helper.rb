module LinkToFunctionHelper
    def link_to_function name, *args, &block
        html_options = args.extract_options!.symbolize_keys

        function = block_given? ? update_page(&block) : args[0] || ''
        onclick = "#{"#{html_options[:onclick]}; " if html_options[:onclick]}#{function}; return false;"
        href = html_options[:href] || '#'

        content_tag(:a, name, html_options.merge(:href => href, :onclick => onclick))
    end
end