class Item < ActiveRecord::Base
  validates :question, presence: true
  validates :answer, presence: true
  validates :review_at, presence: true

  belongs_to :user
end
