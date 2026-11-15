class AddIndexOnLessonAndUserColumnInAttendances < ActiveRecord::Migration[8.1]
  def change
    add_index :attendances, [ :user_id, :lesson_id ], unique: true
  end
end
