class Admin::CategoriesController < Admin::AdminBaseController
  before_action :authenticate_user!
  layout 'admin'

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def edit
    set_category
  end

  def create
    @category = Category.new(params[:category])

    if @category.save
      flash_message :success, t('controllers.admin.categories.create.valid')
      redirect_to admin_categories_url
    else
      render :new
    end
  end

  def update
    set_category
    if @category.update(params[:category])
      flash_message :success, t('controllers.admin.categories.update.valid')
      redirect_to admin_categories_url
    else
      render :edit
    end
  end

  def destroy
    set_category
    @result = Store.last_record(@category, Category.all.count)

    flash_message @result[0], @result[1]
    redirect_to admin_categories_url
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

end
