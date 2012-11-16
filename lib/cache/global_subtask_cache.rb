class GlobalSubtaskCache < GlobalCache

  def store(task)
    if task.class == Task
      super(task.id, task)
    else
      nil
    end
  end

end
