require 'test_helper'

class SourcesControllerTest < ActionController::TestCase
  def setup
  	@current_user = User.create email: "email@email.com"
  end

  test "#new" do
  	get :new
  	json = JSON.parse response.body
  	source = assigns :source

  	assert source.new_record?
  	assert_equal source.as_json, json["source"]
  end

  test "#create" do
  	source = Source.new url: "google.ca", title: "title"
  	post :create, source: source.as_json, format: :json
  	source = assigns :source

  	refute source.new_record?
  	assert Source.all.include? source

  	json = JSON.parse response.body
  	assert_equal source.as_json.values.compact.count, json["source"].values.compact.count
  end

  test "#create with invalid params" do
  	source = Source.new url: "google.ca", title: "title"
  	post :create, source: source.as_json.merge("invalid" => "param"), format: :json
  
  	assert_response :internal_server_error
  	json = JSON.parse response.body

  	assert_equal "Server error: unknown attribute: invalid", json["message"]
  end

  test "#show" do
  	source = Source.create! url: "google.ca", title: "title"
  	get :show, id: source.id, format: :json

  	json = JSON.parse response.body
  	assert_equal source.as_json.values.compact.count, json["source"].values.compact.count
  end

  test "#show not found" do
  	get :show, id: 999, format: :json

		assert_response :not_found
  	json = JSON.parse response.body
  	assert_equal "Not found: 999", json["message"]
  end

  test "#index finds by topic" do
  	topic = Topic.create name: "topic"
  	3.times { topic.sources.create url: "google.ca", title: "title" }
  	unincluded_source = Source.create title: "different topic source"
  	get :index, topic_id: topic.id, format: :json

  	sources = assigns :sources
  	assert_equal 3, sources.size
  	assert_equal topic.sources, sources
  	refute sources.include? unincluded_source

  	json = JSON.parse response.body
  	assert_equal sources.map(&:as_json).map(&:values).map(&:compact).map(&:count), json["sources"].map(&:values).map(&:compact).map(&:count)
  end

  test "#index with no topic id" do
  	topic = Topic.create name: "topic"
  	3.times { topic.sources.create url: "google.ca", title: "title" }
  	get :index, topic_id: nil, format: :json

  	sources = assigns :sources
  	assert_equal 0, sources.size
  end

  test "#destroy" do
  	source = Source.create! url: "google.ca", title: "title"
  	delete :destroy, id: source.id, format: :json

  	json = JSON.parse response.body
  	refute Source.all.include? source
  	assert_equal source.as_json.values.compact.count, json["source"].values.compact.count
  	assert json['deleted']
  end

  test "#destroy not found" do
  	delete :destroy, id: 999, format: :json

		assert_response :not_found
  	json = JSON.parse response.body
  	assert_equal "Not found: 999", json["message"]
  end
end
		