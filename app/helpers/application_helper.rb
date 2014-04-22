module ApplicationHelper

    def link_to_remove_fields name, f, obj
      f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this, '#{obj}')")
    end
      
    # The type parameter defines whether the helper is an ajax trigger, or just a simple form rendering.
    def link_to_add_fields name, f, association, target, tooltip
      new_object = f.object.class.reflect_on_association(association).klass.new
      fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
        render("admin/products/" + association.to_s + "/fields", :f => builder)
      end
      link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\", \"#{target}\")", 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'data-original-title' => tooltip)
    end

    def add_foreign_field f, association
      new_object = f.object.class.reflect_on_association(association).klass.new
      f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
        render("admin/products/" + association.to_s + "/fields", :f => builder)
      end
    end
    
    def active_controller? controller
      "current" if params[:controller] == controller
    end

    def active_category? id
      category = params[:category_id]
      category ||= params[:id]
      "active" if category == id
    end

    def active_page? controller, action
      "active" if params[:controller] == controller && params[:action] == action
    end

    def create_app_breadcrumbs
      @app_breadcrumbs ||= [ { :title => 'Home', :url => root_path }]
    end

    def app_breadcrumb_add title, url
      create_app_breadcrumbs << { :title => title, :url => url }
    end

    def create_admin_breadcrumbs
      @admin_breadcrumbs ||= [ { :title => Store::settings.name, :url => admin_root_path}]
    end

    def breadcrumb_add title, url
      create_admin_breadcrumbs << { :title => title, :url => url }
    end

    def render_breadcrumbs type
      if type == 0
        render :partial => 'shared/admin_breadcrumbs', :locals => { :breadcrumbs => create_admin_breadcrumbs }
      else 
        render :partial => 'shared/app_breadcrumbs', :locals => { :breadcrumbs => create_app_breadcrumbs }
      end
    end

    def table_commands object, show, edit, delete, type
      render :partial => 'shared/table_actions', :locals => { :object => object, :view => show, :edit => edit, :del => delete, :type => type }
    end
    
    def format_currency price
      number_to_currency(price, :unit => Store::settings.currency, :precision => (price.round == price) ? 0 : 2)
    end
    
    def errors_for model, attribute
      if model.errors[attribute].present?
        content_tag :span, :class => 'error_explanation' do
          model.errors[attribute].join(", ")
        end
      end
    end

    def javascript(*files)
      content_for(:footer) { javascript_include_tag(*files) }
    end

end
