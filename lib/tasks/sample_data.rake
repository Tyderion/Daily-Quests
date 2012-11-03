namespace :db do
  desc "Reset and Fill database with sample data"
  task :populate do |t, args|
    Rake::Task['db:reset'].invoke
    make_type
  end

  def make_type
    t = Task.new
    t.typ = "Task"
    t.typ = "Quest"
    t.typ = "Questsequence"
  end

end
