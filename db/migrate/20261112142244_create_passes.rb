class CreatePasses < ActiveRecord::Migration[8.0]
  def change
    create_table :passes do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :entries_total
      t.integer :entries_left
      t.datetime :valid_until

      t.timestamps
    end
  end
end
