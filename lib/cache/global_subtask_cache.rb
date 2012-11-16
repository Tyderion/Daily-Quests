class GlobalSubtaskCache < GlobalCache

  def store(task)
    if task.class == Task
      super(task.id, [task, task.subtasks.map { |e| e.id }])
    else
      nil
    end
  end

  def include?(task)
    @cache[task.id][1] == task.subtasks.map { |e| e.id } if @cache.include? task.id
  end

end
