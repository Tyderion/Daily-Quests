# GlobalCache to store tasks with subtasks in it, used for the validator
#
class GlobalSubtaskCache < GlobalCache

  # Stores a task-snapshot in the cache
  #
  # * *Args*    :
  #   - +task+ -> the Task to store in the Cache
  # * *Returns* :
  #   - the Task stored
  #
  def store(task)
    if task.class == Task
      #Store an array of subtask-ids to be able to detect changes in the subtasks (which need a reevaluation of the validity)
      super(task.id, [task, task.subtasks.map { |e| e.id }])
    else
      nil
    end
  end

  def include?(task)
    @cache[task.id][1] == task.subtasks.map { |e| e.id } if @cache.include? task.id
  end

end
