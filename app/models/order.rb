class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address

  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :user_id, :address_id, :total_price, :amount, :order_no, presence: true
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }

  before_create :gen_order_no

  private

  def gen_order_no
    self.order_no = RandomCode.generate_order_uuid
  end

  def set_amount
    self.amount = order_items.sum(:quantity)
  end
end
