class ShoppingCart < ApplicationRecord
  validates :user_uuid, presence: true
  validates :product_id, presence: true
  validates :amount, presence: true

  belongs_to :product

  scope :by_user_uuid, ->(user_uuid) { where(user_uuid: user_uuid) }
end
