class SubtaskValidator
  def initialize(task)
    @task = task
    @valid= SubtaskCache.new
    @invalid = SubtaskCache.new
  end

  def valid?(task)
    if @valid.include?(task)
      true
    elsif @invalid.include(task)
      false
    elsif task.id == @task.id || !type_valid?(task)
      @invalid.store(task)
      false
    else
      @valid.store(task)
      true
    end

    # if !@valid.include?(task) && ( @invalid.include(task) || task.id == @task.id || !type_valid?(task) )
    #   @invalid.store(task)
    #   return false
    # else
    #   @valid.store(task) unless @valid.include?(task)
    #   return subtasks_valid?(task.subtasks)
    # end
  end

  def subtasks_valid?(subtasks)
    subtasks.each do |task|
      if subtask_valid?(task)
      return false
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
      task.type = "Quest"#TaskType.name_for(2)
    end
  end
end
