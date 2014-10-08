module DynamicRouter

    class << self

        # Iterates through all the active pages and creates a GET route for each one
        #
        def load
            if Store::database_exists? && Page.table_exists?
                Trado::Application.routes.draw do 
                    Page.active.all.each do |page|
                        puts "Routing #{page.slug}"
                        get "/#{page.slug}", to: "pages##{page.template_type}", defaults: { id: page.id }
                    end
                end
            end
        end

        # Reloads the routes
        # This is used whenever a Page record is edited, updated or destroyed
        #
        def reload
            Trado::Application.routes_reloader.reload!
        end
    end
end