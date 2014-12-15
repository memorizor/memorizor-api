class Catagory < ActiveRecord::Base
  validates :name, presence: true
  validates :color, presence: true

  belongs_to :user
  has_and_belongs_to_many :questions
end
