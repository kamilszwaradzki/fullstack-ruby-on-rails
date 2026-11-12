class CreateAttendances < ActiveRecord::Migration[8.0]
  def change
    create_table :attendances do |t|
      t.references :lesson, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :present

      t.timestamps
    end
  end
end
