class ThemePresenter < ActivePresenter::Base
    presents :theme

    def layout_template_path
        return "../themes/#{theme.name}/layout/application"
    end

    def page_template_path page
        unless theme.views.include?(page)
            raise ActionController::RoutingError.new("Template missing for view '#{page}' in '#{theme.page_root}'")
        end
        theme.page_root + page
    end

    def email_template_path email
        unless theme.emails.include?(email)
            raise ActionController::RoutingError.new("Template missing for email '#{email}' in '#{theme.email_root}'")
        end

        theme.email_root + email
    end
end
