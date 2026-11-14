class AddIndexOnUserAndGroupColumnInEnrollments < ActiveRecord::Migration[8.1]
  def change
    add_index :enrollments, [ :user_id, :group_id ], unique: true
  end
end
