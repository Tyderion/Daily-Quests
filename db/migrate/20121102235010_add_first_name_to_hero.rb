class AddFirstNameToHero < ActiveRecord::Migration
  def change
    add_column :heroes, :first_name, :string
  end
end
