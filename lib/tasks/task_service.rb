class TaskService


  def initialize
    @@begins_with = Proc.new {|s| /^#{s}.*$/i }
    @@word_begins_with = Proc.new {|s| /^.* #{s}.*$/i }
  end


  def search_by_title(term, *args)
    options = args.extract_options!
    priv = options[:private].nil? ? false : options[:private]
    tasks = Task.where("private = ? and title LIKE ?",priv, "%#{term}%")
    tasks
  end

  def sort_by(tasks, term)
      first = tasks.find_all{|item| item.title =~ @@begins_with.call(term) }
      second = tasks.find_all{|item| item.title =~ @@word_begins_with.call(term) }
      last = tasks.to_a - first - second
      first + second + last
  end
end
