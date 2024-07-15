class Order < ApplicationRecord
  validates :user_id, presence: true
  validates :produdct_id, presence: true
  validates :address_id, presence: true
  validates :total_price, presence: true
  validates :amount, presence: true
  validates :order_no, presence: true

  belongs_to :user
  belongs_to :product
  belongs_to :address

  before_create :gen_order_no

  private
  def gen_order_no
    self.order_no = RandomCode.generate_order_uuid
  end
end
