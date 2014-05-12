module ApplicationHelper

    # Destroy generated form field object and trigger the associated JavaScript function to remove it from the DOM too
    #
    # @parameter [string, object, object]
    def link_to_remove_fields name, f, obj
      f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this, '#{obj}')")
    end
      
    # Create a new form field object and trigger the associated JavaScript to add the field elements to the DOM
    #
    # @parameter [string, object, object, string, string]
    # @return [object]
    def link_to_add_fields name, f, association, target, tooltip
      new_object = f.object.class.reflect_on_association(association).klass.new
      fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
        render("admin/products/" + association.to_s + "/fields", :f => builder)
      end
      link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\", \"#{target}\")", 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'data-original-title' => tooltip)
    end

    # Add a single form field object to the DOM
    #
    # @parameter [object, object]
    # @return [object]
    def add_foreign_field f, association
      new_object = f.object.class.reflect_on_association(association).klass.new
      f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
        render("admin/products/" + association.to_s + "/fields", :f => builder)
      end
    end

    # Returns a string of a formatted currency, using the currency unit and tax rate set in the Store settings
    #
    # @parameter [decimal]
    # @return [string]
    def gross_price  net_price
      format_currency net_price*Store::tax_rate + net_price
    end
    
    # If the string parameter equals the current controller value in the parameters hash, return a string
    #
    # @parameter [string]
    # @return [string]
    def active_controller? controller
      "current" if params[:controller] == controller
    end

    # Either the id or category_id value from the parameters hash is assigned to an instance variable
    # If the instance variable is equal to the passed in parameter, return a string
    #
    # @parameter [integer]
    # @return [string]
    def active_category? id
      category = params[:category_id]
      category ||= params[:id]
      "active" if category == id
    end

    # If the controller and action values from the parameter hash are equal to the parameters
    # Return a string
    #
    # @parameter [string, string]
    # @return [string]
    def active_page? controller, action
      "active" if params[:controller] == controller && params[:action] == action
    end

    # Create a new object to start building breadcrumbs for the storefront
    #
    # @return [object]
    def create_store_breadcrumbs
      @app_breadcrumbs ||= [ { :title => 'Home', :url => root_path }]
    end

    # Add a new breadcrumb to the storefront breadcrumb object using the parameters
    #
    # @parameter [string, string]
    def store_breadcrumb_add title, url
      create_store_breadcrumbs << { :title => title, :url => url }
    end

    # Create a new object to start building breadcrumbs for the administration area
    #
    # @return [object]
    def create_admin_breadcrumbs
      @admin_breadcrumbs ||= [ { :title => Store::settings.name, :url => admin_root_path}]
    end

    # Add a new breadcrumb to the administration area breadcrumb object using the parameters
    #
    # @parameter [string, string]
    def breadcrumb_add title, url
      create_admin_breadcrumbs << { :title => title, :url => url }
    end

    # Renders the HTML elements for the breadcrumbs
    #
    # @parameter [integer]
    # @return [string]
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
    # @parameter [object, object, object, object, integer]
    # @return [string]
    def table_commands object, show, edit, delete, type
      render :partial => 'shared/table_actions', :locals => { :object => object, :view => show, :edit => edit, :del => delete, :type => type }
    end
    
    # Controllers within the admin namespace do not enable this method to be subject to tax
    # Controllers within the storefront enable this method to be subject to tax
    # If the StoreSetting tax_breakdown property is set to false
    # However if the StoreSetting tax_breakdown property is set to true
    # The method is not subject to tax, but 'inc. VAT' text snippets appear, which utilise the gross_price method labelled above
    #
    # @parameter [decimal]
    # @return [string]
    def format_currency price
      price = Store::settings.tax_breakdown ? price : price*Store::tax_rate+price unless params[:controller].split('/').first == 'admin'
      number_to_currency(price, :unit => Store::settings.currency, :precision => (price.round == price) ? 0 : 2)
    end
    
    # Creates HTML elements and an error associated with the attribute, if one exists
    #
    # @parameter [object, object]
    # @return [string]
    def errors_for model, attribute
      if model.errors[attribute].present?
        content_tag :span, :class => 'error_explanation' do
          model.errors[attribute].join(", ")
        end
      end
    end

    # Creates a JavaScript tag, targeting the associated JavaScript file within the asset pipeline
    # This method is used for page specific JavaScript files
    #
    # @parameter [object]
    # @return [string]
    def javascript(*files)
      content_for(:footer) { javascript_include_tag(*files) }
    end

end
