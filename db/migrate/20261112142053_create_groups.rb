class CreateGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :groups do |t|
      t.references :course, null: false, foreign_key: true
      t.references :instructor, null: false, foreign_key: { to_table: :users }
      t.integer :weekday
      t.datetime :starts_at
      t.integer :duration
      t.integer :capacity

      t.timestamps
    end
  end
end
