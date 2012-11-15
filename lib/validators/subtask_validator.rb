class SubtaskValidator
  def initialize(task)
    @task = task
    @valid_subtasks = []
    @invalid_subtasks = []
  end

  def valid?(task)
    if task.id == @task.id || !type_valid?(task)
      return false
    else
      return subtasks_valid?(task.subtasks)
    end
  end

  def subtasks_valid?(subtasks)
    subtasks.each do |task|
      if subtask_valid?(task)
      return false
    end
    true
  end

  def type_valid?(task)
    if @task.type == TaskType.name_for(1)
      task.type == TaskType.name_for(1)
    elsif @task.type == TaskType.name_for(2)
      task.type == TaskType.name_for(1)
    elsif @task.type == TaskType.name_for(3)
      task.type = TaskType.name_for(2)
    end
  end
end
