class Admin::PagesController < ApplicationController

  layout 'admin'
  before_action :set_page, only: [:edit, :update]
  before_action :list_template_types, only: [:edit, :update]

  def index
    @pages = Page.all
  end

  def edit
  end

  def update
    params[:page][:slug] = params[:page][:slug].parameterize
    if @page.update(params[:page])
      flash_message :success, 'Page was successfully updated.'
      redirect_to admin_pages_url
    else
      render :edit
    end
  end

  private
  
  def set_page
    @page = Page.find(params[:id])
  end

  def list_template_types
    @template_types = Page.template_types
  end
end
