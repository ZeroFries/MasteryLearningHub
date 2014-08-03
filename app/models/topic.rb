class Topic < ActiveRecord::Base
  belongs_to :parent_topic, class_name: "Topic", foreign_key: "topic_id"
  has_many :sources

  def child_topics
  	Topic.where topic_id: self.id
  end
end
