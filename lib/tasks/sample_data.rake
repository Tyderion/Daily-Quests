namespace :db do
  desc "Reset and Fill database with sample data"
  task :populate do |t, args|
    Rake::Task['db:reset'].invoke
    make_type
    make_tasks
    make_subtasks
  end

  def make_type
    t = Task.new
    t.type = "Task"
    t.type = "Quest"
    t.type = "Questsequence"
  end

  def make_tasks
    names = { "Clean Keyboard" => "How to clean your Keyboard",
              "Remove Keys" => "Take away the keys carefully with a knife",
              "Vacuum keyboard" => "Remove all the food which is under the keys",
              "Restore Keys" => "Put the keys back again, mind the layout ;)" }

    names.each do  |key, value|
      Task.create(title: key, description: value, private: false, type: "Task")
    end
    tasks = []
    ('a'..'z').each do |c|
      tasks << Task.create(title: "Remove #{c}", description: "Gently pop the key off with the tip of a knife", private: false, type: "Task")
    end
    Task.find(2).add_subtasks(tasks)

  end

  def make_subtasks
    (2..4).each do |i|
      Subtask.create(task: Task.first, subtask: Task.find(i), position_in_task: i-1)
    end
    # l = ('a'..'z').to_a.size
    # ('a'..'z').each_with_index do |e, i|
    #   Subtask.create(task: Task.find(2), subtask: Task.find_by_title("Remove #{e}"), position_in_task: 25-i)
    # end
  end

end
