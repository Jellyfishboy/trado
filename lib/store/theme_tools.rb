module Store

    class ThemeTools

        # Lists the available themes within the app/views/themes folder
        #
        # @return [Array] list of available themes
        def self.list
            return Dir.glob('app/views/themes/*').map { |theme| theme.split('/').last }
        end
    end
end