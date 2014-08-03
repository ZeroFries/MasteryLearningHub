class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.integer :completed_source_ids, array: true, :default => []
      t.integer :bookmarked_source_ids, array: true, :default => []

      t.timestamps
    end
  end
end
