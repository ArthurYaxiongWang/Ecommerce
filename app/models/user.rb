class User < ApplicationRecord
  authenticates_with_sorcery!

  attr_accessor :password, :password_confirmation

  validates :email, presence: { message: "can't be blank" }, uniqueness: true
  validates :password, presence: { message: "can't be blank" }, length: { minimum: 6, message: "must be at least 6 characters" }, if: :need_validate_password
  validates :password_confirmation, presence: { message: "can't be blank" }, if: :need_validate_password
  validates_confirmation_of :password, message: "doesn't match", if: :need_validate_password

  private

  def need_validate_password
    new_record? || password.present? || password_confirmation.present?
  end
end
