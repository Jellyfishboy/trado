class Admin::PagesController < Admin::AdminBaseController
  layout 'admin'

  def index
    set_pages
  end

  def edit
    set_page
    list_template_types
  end

  def update
    set_page
    list_template_types
    params[:page][:slug] = Store.parameterize_slug(params[:page][:slug])
    if @page.update(params[:page])
      flash_message :success, t('controllers.admin.pages.update.valid')
      redirect_to admin_pages_url
    else
      render :edit
    end
  end

  private
  
  def set_page
    @page ||= Page.find(params[:id])
  end

  def set_pages
    @pages ||= Page.all
  end

  def list_template_types
    @template_types ||= Page.template_types
  end
end
