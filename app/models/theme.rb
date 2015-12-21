class Theme
    attr_reader :name

    def initialize theme_name
        @name = theme_name
    end

    def page_root
        return "themes/#{name}/"
    end

    def email_root
        return "themes/#{name}/mailer/"
    end

    def views
        files = Dir.chdir(Rails.root.join('app/views/', page_root)){ Dir.glob("**/*") }
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
        files = Dir.chdir(Rails.root.join('app/views/', email_root)){ Dir.glob("**/*") }
        files.map do |path|
            path.split('.')[0]
        end.compact
    end
end
