class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :url
      t.string :title
      t.text :description
      t.string :image_url

      t.timestamps
    end
  end
end
