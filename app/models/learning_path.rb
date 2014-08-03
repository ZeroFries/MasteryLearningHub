class LearningPath < ActiveRecord::Base
  belongs_to :topic
  has_many :nodes
end
