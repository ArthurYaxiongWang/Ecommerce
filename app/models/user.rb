class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :province, optional: true

  has_many :addresses, -> { where(address_type: Address::ADDRESS_TYPE::User) }

  belongs_to :default_address, class_name: :Address

  def username
    email.present? ? email.split("@").first : ""
  end
end
