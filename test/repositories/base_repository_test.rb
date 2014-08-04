require 'test_helper'

class BaseRepositoryTest < ActiveSupport::TestCase
  def setup
    @user = User.create email: "email.com"
    @repo = BaseRepository.new Node, @user
  end

  def test_create
    node, status = @repo.create title: "title"
    node.reload

    assert status
    assert_equal "title", node.title
    refute node.new_record?
    refute_nil node.created_at
    refute_nil node.updated_at
  end

  def test_update
    node = @repo.create.first
    node.updated_at = nil
    node.save!
    @repo.update node, title: 'title'

    assert_equal "title", node.title
    refute_nil node.updated_at
  end

  def test_find
    node = @repo.create.first
    nodes, status = @repo.find
    assert status
    assert nodes.include? node
  end

  def test_find_returns_empty
    node = @repo.create.first
    nodes, status = @repo.find title: "doesnt_exist"
    refute status
    refute nodes.include? node
    assert_equal [], nodes
  end

  def test_find_by_id
    node = @repo.create.first
    assert_equal [node, true], @repo.find_by_id(node.id)
  end

  def test_find_by_nil_id
    assert_equal [nil, false], @repo.find_by_id(nil)
  end

  def test_find_and_update
    node = @repo.create.first

    @repo.find_and_update node.attributes.merge('title' => 'title')
    assert_equal 'title', node.reload.title

    @repo.find_and_update node.attributes.merge(title: 'title2')
    assert_equal 'title2', node.reload.title
  end

  def test_find_and_update_non_existent
    node = Node.new
    # no save
    refute @repo.find_and_update(node.attributes).first
    refute @repo.find_and_update(node.attributes).last
  end

  def test_find_and_update_all
    node1 = @repo.create.first
    node2 = @repo.create.first
    node3 = @repo.create.first

    @repo.find_and_update_all [node1.attributes.dup.merge('title' => 'title'), node2.attributes.dup.merge('title' => 'title2'), node3.attributes.dup.merge('title' => 'title3')]
    assert_equal 'title', node1.reload.title
    assert_equal 'title2', node2.reload.title
    assert_equal 'title3', node3.reload.title
  end

  def test_find_and_update_all_rollsback_when_fail
    node1 = @repo.create.first
    node2 = @repo.create.first
    node3 = @repo.create.first

    status = @repo.find_and_update_all([node1.attributes.dup.merge('title' => 'title'), node2.attributes.dup.merge('id' => 999, 'title' => 'title2'), node3.attributes.dup]).last
    refute status
    assert_nil node1.reload.title
    assert_nil node2.reload.title
  end

  def test_delete
    node = @repo.create.first
    assert Node.all.include? node
    @repo.delete node
    refute Node.all.include? node
  end

  def test_find_and_delete
    node = @repo.create.first
    assert Node.all.include? node
    @repo.find_and_delete node.id
    refute Node.all.include? node
  end

  def test_symbolize_attributes
    attributes = { 'id' => 100, :id => 200, 'created_by_id' => '100'}
    assert_equal({ :id => 200, :created_by_id => '100'}, @repo.send(:symbolize_attributes, attributes))
  end
end
