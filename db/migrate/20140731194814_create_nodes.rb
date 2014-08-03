class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.references :learning_path, index: true
      t.references :topic, index: true
      # t.hstore :sources, array: true
      t.integer :source_ids, array: true, :default => []
      t.string :title

      t.timestamps
    end
  end
end
