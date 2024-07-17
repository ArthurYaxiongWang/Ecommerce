class Contact < ApplicationRecord
  validates :title, :content, presence: true
end
