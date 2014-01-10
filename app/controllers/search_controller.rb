class SearchController < ApplicationController

    def results
        @products_solr = Product.search do
                            fulltext params[:query]
                            paginate :page => params[:p_page], :per_page => 30
                        end
        @products = @products_solr.results
        respond_to do |format|
            format.html
        end
    end
end