class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product, optional: true
end
