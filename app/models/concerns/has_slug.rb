module HasSlug
    extend ActiveSupport::Concern

    included do
        extend FriendlyId
        friendly_id :name, use: [:slugged, :finders]
    end
end