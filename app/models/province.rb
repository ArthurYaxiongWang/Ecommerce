class Province < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :name, length: { minimum: 2 }
end
