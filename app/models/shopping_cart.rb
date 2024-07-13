class ShoppingCart < ApplicationRecord
  belongs_to :product
  validates :user_uuid, :product_id, :amount, presence: true

  scope :by_user_uuid, ->(user_uuid) { where(user_uuid: user_uuid) }

  def self.create_or_update(options = {})
    cond = {
      user_uuid: options[:user_uuid],
      product_id: options[:product_id]
    }

    record = where(cond).first
    if record
      record.update!(amount: record.amount + options[:amount])
    else
      record = create!(options)
    end

    record
  end
end
