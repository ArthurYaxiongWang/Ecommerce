class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product, optional: true  # Ensure this is optional

  # Remove all validations temporarily
end
