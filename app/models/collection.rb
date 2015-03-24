class Collection < ActiveRecord::Base
  belongs_to :question
  belongs_to :catagory
end
