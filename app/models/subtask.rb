class Subtask < ActiveRecord::Base
  attr_accessible :subtask, :task, :position_in_task

  validate :subtask, presence: true
  validate :task, presence: true
  #validate :position_in_task, presence: true

  belongs_to :task
  belongs_to :subtask, class_name: "Task"


  delegate :id, :title, :description, :subtasks, :title=, :description=, :add_subtask, :add_subtasks,
           :subtask_valid?, :public?, :private?, :type, :type=,
           to: :subtask


  after_save do |record|
    # unless record.task.subtasks.to_a.include? record
    #   record.task.subtasks << record
    # end
  end


end
