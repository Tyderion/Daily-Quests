class RenameUserNameToLastName < ActiveRecord::Migration
  def up
    rename_column :heroes, :name, :last_name
  end

  def down
    rename_column :heroes, :last_name, :name
  end
end
