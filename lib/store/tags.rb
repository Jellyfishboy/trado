module Store
    class Tags

        # Creates or updates the list of tags for an object with Tag and HABTM Tagging.
        #
        # @return [array]
        def self.add value, product_id
            @tags = value.split(/,\s*/)   
            @tags.each do |t|
                next if Tag.find_by_name(t)
                new_tag = Tag.create(:name => t)
                Tagging.create(:product_id => product_id, :tag_id => new_tag.id)
            end
        end

        # Deletes tags not contained within the comma separated string
        #
        # @return [nil]
        def self.del value, product_id
            @tags = value.split(/,\s*/)
            Tag.where('name NOT IN (?)', @tags).includes(:taggings).where(:taggings => { :product_id => product_id }).destroy_all
        end
    end
end