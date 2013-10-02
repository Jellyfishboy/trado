module ApplicationHelper
    def link_to_remove_fields name, f
      f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
    end
      
    def link_to_add_fields name, f, association
      new_object = f.object.class.reflect_on_association(association).klass.new
      fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
        render(association.to_s.singularize + "_fields", :f => builder)
      end
      link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
    end

    def active_page? page
      "active" if params[:controller] == page
    end

    def create_breadcrumbs
      @breadcrumbs ||= [ { :title => 'Dashboard', :url => '/admin'}]
    end

    def breadcrumb_add title, url
      create_breadcrumbs << { :title => title, :url => url }
    end

    def render_breadcrumbs
      render :partial => 'shared/breadcrumbs', :locals => { :breadcrumbs => create_breadcrumbs }
    end

    def table_commands object, edit
      render :partial => 'shared/table_actions', :locals => { :object => object, :edit => edit }
    end
end
