module Services
	class UserProgress
		attr_accessor :user, :learning_path

		def initialize(user, learning_path)
			@user = user
			@learning_path = learning_path
		end

		def compute_progress
			completed_source_ids = @user.completed_source_ids
			h = {}
			h["learning_path_id"] = @learning_path.id
			h["nodes"] = @learning_path.nodes.map do |node|
				completed_node_source_ids = compute_node_progress node, completed_source_ids
				{
					"node_id" => node.id,
					"completed_source_count" => completed_node_source_ids.size,
					"total_source_count" => node.source_ids.size,
					"completed_source_ids" => completed_node_source_ids
				}
			end
			h
		end

		private

		def compute_node_progress(node, completed_source_ids)
			# set intersection
			node.source_ids & completed_source_ids
		end
	end
end