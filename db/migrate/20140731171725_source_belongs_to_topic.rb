class SourceBelongsToTopic < ActiveRecord::Migration
  def change
  	add_column :sources, :topic_id, :integer
    add_index :sources, :topic_id
  end
end
