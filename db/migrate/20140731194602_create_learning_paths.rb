class CreateLearningPaths < ActiveRecord::Migration
  def change
    create_table :learning_paths do |t|
      t.references :topic, index: true
      t.integer :difficulty
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
