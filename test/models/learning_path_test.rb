require "test_helper"

class LearningPathTest < ActiveSupport::TestCase
	def setup
		@learning_path = LearningPath.create title: "title", description: "learn stuff", difficulty: 0
	end

	test "variables" do
		@learning_path.reload
		assert_equal "title", @learning_path.title
		assert_equal "learn stuff", @learning_path.description
		assert_equal 0, @learning_path.difficulty	
	end	

	test "has many nodes" do
		2.times do |i|
			@learning_path.nodes.create
		end

		assert_equal 2, @learning_path.reload.nodes.size
	end

	test "can have a topic" do
		topic = Topic.create name: "name"
		@learning_path.topic = topic
		@learning_path.save

		assert_equal topic, @learning_path.reload.topic
	end
end
