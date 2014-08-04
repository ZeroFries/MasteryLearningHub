require 'test_helper'

class SourcesControllerTest < ActionController::TestCase
  def setup
  	@current_user = User.create email: "email@email.com"
  end

  test "new" do
  	get :new
  	json = JSON.parse response.body
  	source = assigns :source

  	assert source.new_record?
  	assert_equal source.as_json, json["source"]
  end

  # test "create" do
  # 	source = Source.new url: "google.ca"
  # 	post :create, source: source, format: :json
  # end
end
