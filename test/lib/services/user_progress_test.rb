require "test_helper"

module Services
	class UserProgressTest < ActiveSupport::TestCase
		def setup
			10.times { |i| Source.create title: "resource#{i}" }
			@learning_path = LearningPath.create title: "title", description: "learn stuff", difficulty: 0
			@node_1 = @learning_path.nodes.create title: "node1", source_ids: Source.all[0..4].map(&:id)
			@node_2 = @learning_path.nodes.create title: "node2", source_ids: Source.all[4..7].map(&:id) 
			@node_3 = @learning_path.nodes.create title: "node3", source_ids: Source.all[7..10].map(&:id)
			@user = User.create email: "email@email.com"
			@service = UserProgress.new @user, @learning_path
		end

		test "compute progress with completed resources" do	
			@user.update_attributes! completed_source_ids: [Source.first.id, Source.last.id]
			progress = @service.compute_progress

			assert_equal @learning_path.id, progress["learning_path_id"]
			nodes = progress["nodes"]
			assert_equal 3, nodes.size
			assert_equal nodes.last, {
				"node_id" => @node_1.id,
				"completed_source_count" => 1,
				"total_source_count" => 5,
				"completed_source_ids" => [Source.first.id]
			}
			assert_equal nodes.first, {
				"node_id" => @node_3.id,
				"completed_source_count" => 1,
				"total_source_count" => 3,
				"completed_source_ids" => [Source.last.id]
			}
		end	
	end
end
