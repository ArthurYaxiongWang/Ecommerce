class User < ApplicationRecord
  authenticates_with_sorcery!

  attr_accessor :password, :password_confirmation

  validates :email, presence: { message: "can't be blank" }, uniqueness: true
  validates_format_of :email, with: /\A[^@\s]+@[^@\s]+\z/, message: "must be a valid email address", if: proc { |user| user.email.present? }

  validates :password, presence: { message: "can't be blank" }, length: { minimum: 6, message: "must be at least 6 characters" }, if: :need_validate_password
  validates :password_confirmation, presence: { message: "can't be blank" }, if: :need_validate_password
  validates_confirmation_of :password, message: "doesn't match", if: :need_validate_password

  def username
    self.email.split("@").first
  end

  private

  def need_validate_password
    new_record? || password.present? || password_confirmation.present?
  end
end
