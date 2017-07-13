class Product < ApplicationRecord
  belongs_to :store, optional: true
  has_many :order_items
  has_many :wish_list_items
end