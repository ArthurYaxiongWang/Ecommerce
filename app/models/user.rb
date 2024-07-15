class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :province
  belongs_to :default_address, class_name: :Address, optional: true

  has_many :orders
  has_many :addresses, -> { where(address_type: Address::AddressType::User).order("id desc") }

  def username
    email.present? ? email.split("@").first : ""
  end
end
