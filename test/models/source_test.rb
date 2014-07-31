require 'test_helper'

class SourceTest < ActiveSupport::TestCase
  def setup
  	@source = Source.create url: "google.ca", title: "google", image_url: "google.png", description: "search engine"
  end

  test 'variable initialization' do
  	@source.reload
  	assert_equal "google.ca", @source.url
  	assert_equal "google", @source.title
  	assert_equal "google.png", @source.image_url
  	assert_equal "search engine", @source.description
  end
end
