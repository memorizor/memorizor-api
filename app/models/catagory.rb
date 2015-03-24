class Catagory < ActiveRecord::Base
  validates :name, presence: true
  validates :color, presence: true, format: { with: /\A[a-f0-9]{6}\z/ }

  belongs_to :user
  has_many :collections
  has_many :questions, through: :collections

  def add_questions(question_ids, user)
    question_ids.each do |question_id|
      @question = Question.find_by_id(question_id)
      questions << @question if @question.user == user
    end
  end
end
