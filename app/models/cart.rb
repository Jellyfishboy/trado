class Cart < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :line_items, :dependent => :destroy #a cart has many lineitems, however it is dependent on them. it will not be destroyed if a lineitem still exists within it
end
