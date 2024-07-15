class Address < ApplicationRecord
  validates :user_id, presence: true
  validates :address_type, presence: true
  validates :contact_name, presence: { message: "Contact name cannot be blank" }
  validates :cellphone, presence: { message: "Cellphone cannot be blank" }
  validates :address, presence: { message: "Address cannot be blank" }
  validates :province_id, presence: { message: "Province cannot be blank" }

  belongs_to :user
  belongs_to :province

  attr_accessor :set_as_default

  after_save :set_as_default_address
  before_destroy :remove_self_as_default_address

  module AddressType
    User = "user"
    Order = "order"
  end

  def full_address
    "#{address}, #{province.name}, #{cellphone}"
  end

  private

  def set_as_default_address
    if self.set_as_default.to_i == 1
      self.user.default_address = self
      self.user.save!
    else
      if self.user.default_address == self
        self.user.default_address = nil
        self.user.save!
      else
        remove_self_as_default_address
      end
    end
  end

  def remove_self_as_default_address
    if self.user.default_address == self
      self.user.default_address = nil
      self.user.save!
    end
  end
end
