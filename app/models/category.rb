class Category < ApplicationRecord
  validates :title, presence: { message: "Name can't be blank" }
  validates :title, uniqueness: { message: "Name has already been taken" }
  validates :weight, :products_counter, numericality: { only_integer: true }

  has_ancestry orphan_strategy: :destroy

  has_many :products, dependent: :destroy

  before_validation :correct_ancestry

  def self.grouped_data
    self.roots.order("weight desc").inject([]) do |result, parent|
      row = []
      row << parent
      row << parent.children.order("weight desc")
      result << row
    end
  end

  private

  def correct_ancestry
    self.ancestry = nil if self.ancestry.blank?
  end
end
