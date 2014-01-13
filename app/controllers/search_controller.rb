class SearchController < ApplicationController

    def results
        @products_solr = Product.search do
                            fulltext params[:query]
                            paginate :page => params[:p_page], :per_page => 30
                        end
        @products = @products_solr.results
        @products_count = @products_solr.total
        if @products_count > 0
            @products_json = @products.map do |p|
                {
                    :value => p.name,
                    :tokens => p.name,
                    :category_slug => p.category.slug,
                    :category_name => p.category.name,
                    :product_slug => p.slug,
                    :image => p.attachments.first.file.small
                }
            end
        else
            @products_json = []
        end
        respond_to do |format|
            format.json { render :json => @products_json }
            format.html
        end
    end
end