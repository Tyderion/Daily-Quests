class SubtaskValidatorWithCache
  def initialize(task)
    @task = task
    @valid= GlobalSubtaskCache.new(key: task.id*2)
    @invalid = GlobalSubtaskCache.new(key: task.id*2-1)
  end

  def valid?(task)
    _task = task
    task = task.subtask if task.class == Subtask
    if @valid.include?(task)
      true
    elsif @invalid.include?(task)
      false
    elsif task.id == @task.id || !type_valid?(task)
      @invalid.store(task)
      false
    else
      if subtasks_valid?(task.subtasks)
        @valid.store(task)
        true
      else
        @invalid.store(task)
        false
      end
    end
  end

  def subtasks_valid?(subtasks)
    subtasks.each do |task|
      return false unless valid?(task)
    end
    true
  end


  #Todo: Nicer type-validation
  def type_valid?(task)
    if @task.type == "Task"#TaskType.name_for(1)
      task.type == "Task"#TaskType.name_for(1)
    elsif @task.type == "Quest"#TaskType.name_for(2)
      task.type == "Task"#TaskType.name_for(1)
    elsif @task.type == "Questsequence"#TaskType.name_for(3)
      task.type == "Quest"#TaskType.name_for(2)
    end
  end
end
