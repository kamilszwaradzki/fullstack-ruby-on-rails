class CreateLessons < ActiveRecord::Migration[8.0]
  def change
    create_table :lessons do |t|
      t.references :group, null: false, foreign_key: true
      t.datetime :starts_at
      t.datetime :cancelled_at

      t.timestamps
    end
  end
end
