class Question < ActiveRecord::Base
  validates :content, presence: true
  validates :review_at, presence: true
  validates :type, presence: true

  has_many :answer
  belongs_to :user
end
