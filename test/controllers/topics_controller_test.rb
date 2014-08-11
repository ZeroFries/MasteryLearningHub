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

  test "#destroy" do
  	topic = Topic.create name: "topic"
  	topic = topic.topics.create! name: "name"
  	delete :destroy, id: topic.id, format: :json

  	json = JSON.parse response.body
  	refute Topic.all.include? topic
  	assert topic.reload.topics.empty?
  	assert_equal topic.as_json.values.compact.count, json["topic"].values.compact.count
  	assert json['deleted']
  end

  test "#destroy not found" do
  	delete :destroy, id: 999, format: :json

		assert_response :not_found
  	json = JSON.parse response.body
  	assert_equal "Not found: 999", json["message"]
  end
end
