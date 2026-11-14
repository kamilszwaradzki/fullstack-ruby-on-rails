class AddIndexOnGroupAndStartsAtColumnInLessons < ActiveRecord::Migration[8.1]
  def change
    add_index :lessons, [ :group_id, :starts_at ], unique: true
  end
end
