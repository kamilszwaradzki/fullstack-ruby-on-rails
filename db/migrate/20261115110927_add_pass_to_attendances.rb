class AddPassToAttendances < ActiveRecord::Migration[8.1]
  def change
    add_reference :attendances, :pass, null: true, foreign_key: true
  end
end
