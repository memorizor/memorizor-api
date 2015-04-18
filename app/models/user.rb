class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, (options[:message] || 'is not an email') unless
      value =~ /\A([^@\s]+)@((?:[-a-z0-9_]+\.)+[a-z]{2,})\z/i
  end
end

class User < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    email: true
  validates :plan, presence: true, inclusion: { in: [0, 1, 2] }

  has_secure_password
  validates :password, presence: true, on: :create

  has_many :questions
  has_many :catagories

  LIMITS = [999_999, 100, 500]

  def reviews
    questions.where('review_at < ?', Time.zone.now)
  end

  def within_plan?
    questions.count <= LIMITS[plan]
  end

  def can_create?
    questions.count < LIMITS[plan]
  end
end
