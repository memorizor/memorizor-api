class Catagory < ActiveRecord::Base
  validates :name, presence: true
  validates :color, presence: true, format: { with: /\A[a-f0-9]{6}\z/ }

  belongs_to :user
  has_and_belongs_to_many :questions
end
