class Order < ApplicationRecord
  belongs_to :user, optional: true
  has_many :order_items
  belongs_to :order_status, optional: true
  before_create :set_order_status
  before_save :update_subtotal

  def subtotal
    order_items.collect { |oi| oi.valid? ? (oi.quantity * oi.unit_price.to_f) : 0 }.sum
  end

  private
    def set_order_status
      self.order_status_id = 1
    end

    def update_subtotal
      self[:order_total] = subtotal
    end
end
