class Question < ActiveRecord::Base
  validates :content, presence: true
  validates :review_at, presence: true
  validates :answer_type, presence: true, inclusion: { in: [0] }
  validates :level, presence: true

  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :collections
  has_many :catagories, through: :collections

  SRS = [6, 12, 24, 48, 168, 336, 730, 4383]
  SRS_TIME = [SRS[0], SRS[1], SRS[1], SRS[1], SRS[2], SRS[2], SRS[2], SRS[3],
              SRS[3], SRS[3], SRS[4], SRS[4], SRS[4], SRS[5], SRS[5], SRS[5],
              SRS[6], SRS[6], SRS[6], SRS[7]]

  LEVEL_DROP_ON_INCORRECT = 3

  def correct
    self.level += 1 if level < (SRS_TIME.length - 1)
    calculate_review_time
    save!
  end

  def incorrect
    self.level -= LEVEL_DROP_ON_INCORRECT
    self.level = 0 if level < 0
    calculate_review_time
    save!
  end

  def reviewable?
    # puts "\n #{review_at < Time.zone.now} #{review_at} < #{Time.zone.now}\n"
    review_at < Time.zone.now
  end

  private

  def calculate_review_time
    self.review_at = SRS_TIME[level].hours.from_now
  end
end
