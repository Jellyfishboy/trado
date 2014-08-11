# Country Documentation
#
# The country table is a list of available countries available to a user when they select their billing and shipping country. 
# It has and belongs to zones and tax_rates.

# == Schema Information
#
# Table name: countries
#
#  id                   :integer          not null, primary key
#  name                 :string(255)     
#  language             :string(255)
#  iso                  :string(255)
#  zone_id              :integer          not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Country < ActiveRecord::Base

  attr_accessible :name, :iso, :available, :language

  belongs_to :zone

  validates :name,                              :uniqueness => true, :presence => true

  default_scope { order(name: :asc) }

end
