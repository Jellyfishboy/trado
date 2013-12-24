module ApplicationHelper
    def link_to_remove_fields name, f, obj
      f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this, '#{obj}')", :class => 'btn btn-danger btn-mini')
    end
      
    # The type parameter defines whether the helper is an ajax trigger, or just a simple form rendering.
    def link_to_add_fields name, f, association, target
      new_object = f.object.class.reflect_on_association(association).klass.new
      fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
        render(association.to_s.singularize + "_fields", :f => builder)
      end
      link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\", \"#{target}\")", :class => 'btn btn-success btn-mini add_field')
    end

    def add_foreign_field f, association
      new_object = f.object.class.reflect_on_association(association).klass.new
      f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
        render(association.to_s.singularize + "_fields", :f => builder)
      end
    end

    def active_controller? controller
      "active" if params[:controller] == controller
    end

    def active_category? id
      category = params[:category_id]
      category ||= params[:id]
      "active" if category.to_i == id
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
      @admin_breadcrumbs ||= [ { :title => 'Dashboard', :url => admin_root_path}]
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

    # type 2 is for displaying a delivery cost icon for orders, type 1 is for hiding the show icon and 0 is everything else
    def table_commands object, show, edit, delete, type
      render :partial => 'shared/table_actions', :locals => { :object => object, :view => show, :edit => edit, :del => delete, :type => type }
    end

    def del_table_command object
      render :partial => 'shared/del_action', :locals => { :object => object }
    end 

    def format_currency price
      number_to_currency(price, :unit => "&pound;", :precision => (price.round == price) ? 0 : 2)
    end

    def format_final_total total, shipping
      final_total = total + shipping
      format_currency(final_total)
    end

    def shipping_status status
      if status == "Pending"
        "<span class='label label-warning'>#{status}</span>".html_safe
      elsif status == "Dispatched"
        "<span class='label label-success'>#{status}</span>".html_safe
      end
    end
    
    def payment_status status
      if status == "Pending"
        "<span class='label label-warning'>#{status}</span>".html_safe
      elsif status == "Complete"
        "<span class='label label-success'>#{status}</span>".html_safe
      end
    end

    def boolean_helper obj, first, second
      if obj == true
        return first
      else
        return second
      end
    end

    def readonly_helper obj
      if obj == false
        true
      else 
        false
      end
    end
end
