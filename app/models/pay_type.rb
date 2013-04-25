class PayType < ActiveRecord::Base
  attr_accessible :name
  def self.names
    all.collect { |pay_type| pay_type.name }
  end #collects all the columns in paytype db by name and assigns to method 'name'
end
