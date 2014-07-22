module ApplicationHelper

    # Destroy generated form field object and trigger the associated JavaScript function to remove it from the DOM too
    #
    # @param name [String]
    # @param f [Object]
    # @param obj [Object]
    def link_to_remove_fields name, f, obj
      f.hidden_field(:_destroy) + link_to(name, '#/', onclick: "trado.admin.removeField(this, '#{obj}')")
    end
      
    # Create a new form field object and trigger the associated JavaScript to add the field elements to the DOM
    #
    # @param name [String]
    # @param f [Object]
    # @param association [Symbol]
    # @param target [String]
    # @param tooltip [String]
    # @return [Object] new form field using Ajax
    def link_to_add_fields name, f, association, target, tooltip
      new_object = f.object.class.reflect_on_association(association).klass.new
      fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
        render("admin/products/" + association.to_s + "/fields", :f => builder)
      end
      link_to name, '#/', onclick: "trado.admin.addField(this, \"#{association}\", \"#{escape_javascript(fields)}\", \"#{target}\")", 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'data-original-title' => tooltip
    end

    # Add a single form field object to the DOM
    #
    # @param f [Object]
    # @param association [Symbol]
    # @return [Object] new form field
    def add_foreign_field f, association
      new_object = f.object.class.reflect_on_association(association).klass.new
      f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
        render("admin/products/" + association.to_s + "/fields", :f => builder)
      end
    end

    # Returns an array of categories which are visible and ordered by their ascending weighting value
    # Including product data for the links
    #
    # @return [Array] list of categories
    def category_list
      Category.joins(:products).where('visible = ?', true).order(sorting: :asc)
    end
    
    # If the string parameter equals the current controller value in the parameters hash, return a string
    #
    # @param controller [String]
    # @return [String] class name for a HTML element
    def active_controller? controller
      "current" if params[:controller] == controller
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
    # @return [String] class name for a HTML element
    def active_page? controller, action
      "active" if params[:controller] == controller && params[:action] == action
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
      @admin_breadcrumbs ||= [ { :title => Store::settings.name, :url => admin_root_path}]
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
        render :partial => 'shared/breadcrumbs/admin', :locals => { :breadcrumbs => create_admin_breadcrumbs }
      else 
        render :partial => 'shared/breadcrumbs/store', :locals => { :breadcrumbs => create_store_breadcrumbs }
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
    def table_commands object, show, edit, delete, type
      render :partial => 'shared/table_actions', :locals => { :object => object, :view => show, :edit => edit, :del => delete, :type => type }
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
    def javascript *files
      content_for(:footer) { javascript_include_tag(*files) }
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
    def render_flash
        flash_array = []
        flash.each do |type, messages|
            if messages.is_a?(String)
                flash_array << render(partial: 'shared/flash/admin', locals: { :type => type, :message => messages })
            else
                messages.each do |m|
                    flash_array << render(partial: 'shared/flash/admin', locals: { :type => type, :message => m }) unless m.blank?
                end
            end
        end
        flash_array.join('').html_safe
    end
end
