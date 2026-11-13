class AddAuthenticationToUsers < ActiveRecord::Migration[8.1]
  def change
    rename_column :users, :email, :email_address
    change_column_null :users, :email_address, false
    add_column :users, :password_digest, :string, null: false
    add_index :users, :email_address, unique: true
  end
end
