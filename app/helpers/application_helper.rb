module ApplicationHelper

    # Returns an array of categories which are active
    # Including published product data for the links
    #
    # @return [Array] list of categories
    def category_list
        Category.joins(:products).active.where(products: { status: 1 } ).group('categories.id')
    end

    # Returns an array of pages which are active 
    #
    # @return [Array] list of pages
    def page_list
        Page.active.all
    end
    
    # If the string parameter equals the current controller value in the parameters hash, return a string
    #
    # @param controller [String]
    # @param action [String]
    # @return [String] class name for a HTML element
    def active_controller? data
        if data[:action].nil?
            "current" if params[:controller] == data[:controller]
        else
            "current" if params[:controller] == data[:controller] && params[:action] == data[:action]
        end
    end

    # Either the id or category_id value from the parameters hash is assigned to an instance variable
    # If the instance variable is equal to the passed in parameter, return a string
    #
    # @param id [Integer]
    # @return [String] class name for a HTML element
    def active_category? id
        category = params[:category_id]
        category ||= params[:id]
        "active" if category == id
    end

    # If the controller and action values from the parameter hash are equal to the parameters
    # Return a string
    #
    # @param controller [String]
    # @param action [String]
    # @param id [Integer]
    # @return [String] class name for a HTML element
    def active_page? data
        if data[:slug].nil?
            "active" if params[:controller] == data[:controller] && params[:action] == data[:action]
        else
            "active" if params[:controller] == data[:controller] && params[:slug] == data[:slug]
        end
    end

    # Create a new object to start building breadcrumbs for the store area
    #
    # @return [Object] breadcrumbs for the current page in the store area
    def create_store_breadcrumbs
        @app_breadcrumbs ||= [ { :title => 'Home', :url => root_path }]
    end

    # Add a new breadcrumb to the storefront breadcrumb object using the parameters
    #
    # @param title [String]
    # @param url [String]
    def store_breadcrumb_add title, url
        create_store_breadcrumbs << { :title => title, :url => url }
    end

    # Create a new object to start building breadcrumbs for the administration area
    #
    # @return [Object] breadcrumbs for the current page in the administration area
    def create_admin_breadcrumbs
        @admin_breadcrumbs ||= [ { :title => Store.settings.name, :url => admin_root_path}]
    end

    # Add a new breadcrumb to the administration area breadcrumb object using the parameters
    #
    # @param title [String]
    # @param url [String]
    def breadcrumb_add title, url
        create_admin_breadcrumbs << { :title => title, :url => url }
    end

    # Renders the HTML elements for the breadcrumbs
    #
    # @param type [Integer]
    # @return [String] HTML elements
    def render_breadcrumbs type
        if type == 0
            render partial: 'shared/breadcrumbs', locals: { breadcrumbs: create_admin_breadcrumbs }
        else 
            render partial: theme_presenter.page_template_path('shared/breadcrumbs'), locals: { breadcrumbs: create_store_breadcrumbs }
        end
    end

    # Creates HTML elements for the table actions with the administration area
    # The visible actions are dependent on the type parameter
    #
    # @param object [Object]
    # @param show [Object]
    # @param edit [Object]
    # @param delete [Object]
    # @param type [Integer]
    # @return [String] HTML elements
    def table_actions object, *args
        show = args.include?('show')
        edit = args.include?('edit')
        remote_edit = args.include?('remote-edit')
        delete = args.include?('delete')
        remote_delete = args.include?('remote-delete')
        order_record = Store.class_name(object.last) == 'Order'
        sku_record = Store.class_name(object.last) == 'Sku'
        delivery_service_record = Store.class_name(object.last) == 'Delivery Service'      
        render partial: 'shared/table_actions', format: [:html], locals: 
        { 
            object: object, 
            show: show, 
            edit: edit, 
            del: delete, 
            remote_edit: remote_edit,
            remote_delete: remote_delete, 
            order_record: order_record, 
            sku_record: sku_record, 
            delivery_service_record: delivery_service_record 
        }
    end
    
    # Creates HTML elements and an error associated with the attribute, if one exists
    #
    # @param model [Object]
    # @param attribute [Object]
    # @return [String] error message
    def errors_for model, attribute
        if model.errors[attribute].present?
            content_tag :span, :class => 'error-explanation' do
                model.errors[attribute].join(", ")
            end
        end
    end

    # Creates a JavaScript tag, targeting the associated JavaScript file within the asset pipeline
    # This method is used for page specific JavaScript files
    #
    # @overload set(value)
    #   @param [String] javascript file name
    # @return [String] javascript tags
    def javascript location, *files
        content_for(location) { javascript_include_tag(*files) }
    end

    # Adds a message to the relevant flash type array (error, notice or success) 
    #
    # @param [Symbol] flash type
    # @param [String] message
    def flash_message type, text
        flash[type] ||= []
        flash[type] << text
    end   

    # Iterates through each flash message in the array and renders it to the DOM with a partial
    #
    # @return [String] HTML elements
    def render_flash partial
        flash_array = []
        flash.each do |type, messages|
            if messages.is_a?(String)
                flash_array << render(partial: partial, format: [:html], locals: { type: type, message: messages })
            else
                messages.each do |m|
                    flash_array << render(partial: partial, format: [:html], locals: { type: type, message: m }) unless m.blank?
                end
            end
        end
        flash_array.join('').html_safe
    end
end
