class Topic < ActiveRecord::Base
  belongs_to :parent_topic, class_name: "Topic", foreign_key: "topic_id"
  # has_many :child_topics, class_name: "Topic", foreign_key: "id"

  def child_topics
  	Topic.where topic_id: self.id
  end
end
