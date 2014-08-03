require "test_helper"

class NodeTest < ActiveSupport::TestCase
	def setup
		@node = Node.create 
	end

	test "can have multiple source_ids" do
		3.times { |i| Source.create url: "google.ca", title: "source #{i}", image_url: "google.png", description: "search engine" }
		@node.source_ids = Source.all.pluck(:id)
		@node.save
		assert_equal 3, @node.reload.source_ids.size		
	end

	test "can have multiple sources" do
		assert_equal [], @node.reload.source_ids	

		3.times { |i| Source.create url: "google.ca", title: "source #{i}", image_url: "google.png", description: "search engine" }
		@node.source_ids = Source.all.pluck(:id)
		@node.save
		assert_equal 3, @node.reload.sources.size		
	end
end
