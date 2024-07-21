class CartItem < ApplicationRecord
  belongs_to :shopping_cart
  belongs_to :product

  def total_price
    product.price * quantity
  end
end
