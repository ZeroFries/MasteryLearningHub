require "test_helper"

class TopicTest < ActiveSupport::TestCase

  def setup
  	@topic = Topic.create name: "name"
  end

  test 'variable initialization' do
  	@topic.reload
  	assert_equal "name", @topic.name
  end

  test 'can nest infinitely' do
  	topic = Topic.create name: "topic_0", topic_id: @topic.id
  	assert topic.valid?
  	assert topic.parent_topic = @topic

  	3.times { |i| Topic.create name: "topic_#{i+1}", topic_id: Topic.last.id }
  	3.times do |i|
  		topic = Topic.where(name: "topic_#{i+1}").first
  		assert_equal "topic_#{i}", topic.parent_topic.name
  		assert_equal "topic_#{i+2}", topic.child_topics.first.name unless i == 2
  	end
  end

  test 'can have sources' do
  	source = @topic.sources.create url: "google.ca", title: "google", image_url: "google.png", description: "search engine"
  	assert_equal source, @topic.reload.sources.first
  end

end
