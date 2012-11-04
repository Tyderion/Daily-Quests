class AddPositionInTaskToSubtask < ActiveRecord::Migration
  def change
    add_column :subtasks, :position_in_task, :integer
  end
end
