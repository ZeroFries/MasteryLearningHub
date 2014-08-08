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
end
