class PayType < ActiveRecord::Base
  attr_accessible :name
  def self.names
    all.collect { |pay_type| pay_type.name }
  end
end
