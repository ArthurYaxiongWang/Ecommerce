class Contact < ApplicationRecord
  validates :title, :content, presence: true
  validates :content, presence: true
   
end
