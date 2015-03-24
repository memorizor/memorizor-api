class Question < ActiveRecord::Base
  validates :content, presence: true
  validates :review_at, presence: true
  validates :answer_type, presence: true, inclusion: { in: [0] }

  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :collections
  has_many :catagories, through: :collections
end
