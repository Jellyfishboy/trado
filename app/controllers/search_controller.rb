class SearchController < ApplicationController
    skip_before_action :authenticate_user!
    
    def results
        set_query
        @products = Product.includes(:attachments, :category, :skus).published.search(@query, params[:page], 30, 300)
        render theme_presenter.page_template_path('search/results'), format: [:html], layout: theme_presenter.layout_template_path
    end

    def autocomplete
        set_query
        @json_products = Product.search(@query, params[:page], 4, 4).map do |p|
                        {
                                :value => p.name,
                                :tokens => p.name,
                                :category_slug => p.category.slug,
                                :category_name => p.category.name,
                                :product_slug => p.slug,
                                :image => p.attachments.first.file.square
                        }
        end 
        render json: @json_products, status: 200
    end 

    private 

    def set_query
        @query = params[:query].nil? ? "" : params[:query]
    end
end