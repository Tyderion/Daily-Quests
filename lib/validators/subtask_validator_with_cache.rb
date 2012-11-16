# Class to validate subtasks for a specific task
#
class SubtaskValidatorWithCache
  # Create a new Validator object
  #
  # * *Args*    :
  #   - +task+ -> Task to be validated for
  # * *Returns* :
  #   - a new SubtaskValidatorWithCache
  #
  def initialize(task)
    @task = task
    @valid= GlobalSubtaskCache.new(key: task.id*2)
    @invalid = GlobalSubtaskCache.new(key: task.id*2-1)
  end


  public


    # Tests if a given task is a valid subtask to the Task this Validator corresponds to
    #
    # * *Args*    :
    #   - +task+ -> Task to be tested for Subtask-validity
    # * *Returns* :
    #   - Boolean indicating validity of that task as subtask
    #
    def valid?(task)
      if @invalid.include?(task) || !type_valid?(task) ||  task.id == @task.id || !subtasks_valid?(task.subtasks)
        @invalid.include?(task) || @invalid.store(task)
        false
      else
        # WHen subtasks change, just validate the difference
        @valid.include?(task) || @valid.store(task)
        true
      end
    end

    # Returns an array of all invalid keys
    # * *Returns* :
    #   - Array of Task IDs
    #
    def invalid
      @invalid.keys
    end

  private
    def subtasks_valid?(subtasks)
      valid = true
      subtasks.each do |task|
        valid = false unless valid?(task.subtask)
      end
      valid
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
