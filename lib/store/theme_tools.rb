module Store

    class ThemeTools

        def self.list
            return Dir.glob('app/views/themes/*').map { |theme| theme.split('/').last }
        end
    end
end