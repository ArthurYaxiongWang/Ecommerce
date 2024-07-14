class Address < ApplicationRecord
  validates :user_id, presence: true
  validates :address_type, presence: true
  validates :contact_name, presence: { message: "Contact name cannot be blank" }
  validates :cellphone, presence: { message: "Cellphone cannot be blank" }
  validates :address, presence: { message: "Address cannot be blank" }
  validates :province_id, presence: { message: "Province cannot be blank" }

  belongs_to :user
  belongs_to :province

  module AddressType
    User = "user"
    Order = "order"
  end
end
