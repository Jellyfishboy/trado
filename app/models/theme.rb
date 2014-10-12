class Theme

    def initialize store_setting
        @store_setting = store_setting
        @theme_name = @store_setting.theme_name
    end

    def name
        @theme_name
    end

    def page_root
        return "themes/#{@theme_name}/"
    end

    def email_root
        return "themes/#{@theme_name}/mailer/"
    end

    def views
        files = Dir.chdir('app/views/' + page_root){ Dir.glob("**/*") }
        files.map do |path| 
            next if path.include?('layout') || path.include?('mailer')
            path = path.split('.')[0].split('/')
            if path.last.include?('_')
                formatted_file = path.last.delete('_')
                path.delete(path.last)
                path << formatted_file
            end
            path = path.join('/')
            path
        end.compact
    end

    def emails
        files = Dir.chdir('app/views/' + email_root){ Dir.glob("**/*") }
        files.map do |path|
            path.split('.')[0]
        end.compact
    end
end
