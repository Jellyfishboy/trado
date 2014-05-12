class SearchController < ApplicationController

    skip_before_filter :authenticate_user!
    
    def results
        @products = Product.search params[:query], page: params[:page], per_page: 30, fields: [:name, :part_number, :sku]
        respond_to do |format|
            format.html
        end
    end

    def autocomplete
        @json_products = Product.search(params[:query], fields: [{name: :word_start}], limit: 5, partial: true).map do |p|
                        {
                                :value => p.name,
                                :tokens => p.name,
                                :category_slug => p.category.slug,
                                :category_name => p.category.name,
                                :product_slug => p.slug,
                                :image => p.attachments.first.file.small
                        }
        end
        respond_to do |format|
            format.json { render json: @json_products }
        end
    end 
end