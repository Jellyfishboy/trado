module PaginationHelper
    extend ActiveSupport::Concern

    included do

        def page
            params[:page].present? ? (params[:page].to_i <= 0 ? 1 : params[:page].to_i) : 1
        end

        def limit
            params[:limit].present? ? (params[:limit].to_i < 0 ? 50 : params[:limit].to_i) : 50
        end

        def set_query
            @query = params[:query].nil? ? "" : params[:query].downcase
        end
    end
end
    