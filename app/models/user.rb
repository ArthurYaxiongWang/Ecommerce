class User < ApplicationRecord
  unless ENV['RAILS_DOCKER_BUILD']
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable
  end

  belongs_to :province
  belongs_to :default_address, class_name: :Address, optional: true

  has_many :orders
  has_many :addresses, -> { where(address_type: Address::AddressType::User).order("id desc") }

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :province_id, presence: true
  validates :address, presence: true
  validates :default_address_id, presence: true

  attr_accessor :skip_default_address_validation

  def username
    email.present? ? email.split("@").first : ""
  end
end
