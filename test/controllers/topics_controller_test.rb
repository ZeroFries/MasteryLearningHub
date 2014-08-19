require "test_helper"

class TopicsControllerTest < ActionController::TestCase
	def setup
  	@current_user = User.create email: "email@email.com"
  end

  test "#new" do
  	get :new
  	json = JSON.parse response.body
  	topic = assigns :topic

  	assert topic.new_record?
  	assert_equal topic.as_json, json["topic"]
  end

  test "#create" do
  	topic = Topic.new name: "name"
  	post :create, topic: topic.as_json, format: :json
  	topic = assigns :topic

  	refute topic.new_record?
  	assert Topic.all.include? topic

  	json = JSON.parse response.body
  	assert_equal topic.as_json.values.compact.count, json["topic"].values.compact.count
  end

  test "#create with invalid params" do
  	topic = Topic.new name: "name"
  	post :create, topic: topic.as_json.merge("invalid" => "param"), format: :json
  
  	assert_response :internal_server_error
  	json = JSON.parse response.body

  	assert_equal "Server error: unknown attribute: invalid", json["message"]
  end

  test "#show" do
  	topic = Topic.create! name: "name"
  	get :show, id: topic.id, format: :json

  	json = JSON.parse response.body
  	assert_equal topic.as_json.values.compact.count, json["topic"].values.compact.count
  end

  test "#show not found" do
  	get :show, id: 999, format: :json

		assert_response :not_found
  	json = JSON.parse response.body
  	assert_equal "Not found: 999", json["message"]
  end

  test "#update" do
  	parent_topic = Topic.create! name: "parent name"
  	new_parent_topic = Topic.create! name: "new parent name"
  	topic = Topic.create! name: "name", topic_id: parent_topic.id
  	get :show, id: topic.id, format: :json

  	json = JSON.parse response.body
  	topic_json = json["topic"]
  	topic_json["name"] = "new name"
  	topic_json["topic_id"] = new_parent_topic.id

  	put :update, id: topic.id, topic: topic_json, format: :json
  	assert_equal topic.reload.as_json.values.compact.count, json["topic"].values.compact.count
  	assert_equal "new name", topic.name
  	assert_equal new_parent_topic, topic.parent_topic
  end

  test "#update not found" do
  	put :update, id: 999, topic: {}, format: :json

		assert_response :not_found
  	json = JSON.parse response.body
  	assert_equal "Not found: 999", json["message"]
  end

  test "#update with invalid params" do
  	topic = Topic.create name: "name"
  	put :update, id: topic.id, topic: topic.as_json.merge("invalid" => "param"), format: :json
  
  	assert_response :internal_server_error
  	json = JSON.parse response.body

  	assert_equal "Server error: unknown attribute: invalid", json["message"]
  end

  test "#destroy" do
  	topic = Topic.create name: "topic"
  	delete :destroy, id: topic.id, format: :json

  	json = JSON.parse response.body
  	refute Topic.all.include? topic
  	assert json["deleted"]
  end

  test "#destroy not found" do
  	delete :destroy, id: 999, format: :json

		assert_response :not_found
  	json = JSON.parse response.body
  	assert_equal "Not found: 999", json["message"]
  end
end
