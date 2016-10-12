# Tagging Documentation
#
# The tagging table is a HABTM relationship handler between the tags and products tables.
# == Schema Information
#
# Table name: taggings
#
#  id         :integer          not null, primary key
#  tag_id     :integer
#  product_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Tagging < ActiveRecord::Base

    attr_accessible :product_id, :tag_id

    belongs_to :product
    belongs_to :tag

    validates :tag_id,                    uniqueness: { scope: :product_id }
end
