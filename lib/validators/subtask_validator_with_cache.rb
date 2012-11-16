class SubtaskValidatorWithCache
  def initialize(task)
    @task = task
    @valid= GlobalSubtaskCache.new(key: task.id*2)
    @invalid = GlobalSubtaskCache.new(key: task.id*2-1)
  end

  def valid?(task)
    if @invalid.include?(task) || !type_valid?(task) ||  task.id == @task.id || !subtasks_valid?(task.subtasks)
      @invalid.include?(task) || @invalid.store(task)
      false
    else
      @valid.include?(task) || @valid.store(task)
      true
    end
  end

  def subtasks_valid?(subtasks)
    subtasks.each do |task|
      return false unless valid?(task.subtask)
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
