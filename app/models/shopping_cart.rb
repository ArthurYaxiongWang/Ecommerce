class ShoppingCart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  scope :by_user_uuid, ->(user_uuid) { where(user_uuid: user_uuid) }

  def self.create_or_update(options = {})
    shopping_cart = find_or_create_by(user_uuid: options[:user_uuid], user_id: options[:user_id])
    cond = { product_id: options[:product_id] }
    record = shopping_cart.cart_items.find_or_initialize_by(cond)
    record.quantity = options[:quantity].to_i
    record.save!
    record
  end

  def total_price
    cart_items.includes(:product).reduce(0) { |sum, cart_item| sum + cart_item.total_price }
  end
end
