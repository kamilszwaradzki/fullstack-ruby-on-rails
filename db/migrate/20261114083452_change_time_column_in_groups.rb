class ChangeTimeColumnInGroups < ActiveRecord::Migration[8.1]
  def up
    change_column :groups, :starts_at, :time
  end
  def down
    change_column :groups, :starts_at, :datetime
  end
end
