require File.join(File.dirname(__FILE__), '../../config/environment')
require 'database_cleaner'


namespace :dailyquest do
  namespace :data do

    task :delete do
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.clean
    end

    task load: [:'generate:types', :'generate:simple_tasks'] do
      #Do Nothing...
    end

    task :reload do
      Rake::Task['dailyquest:data:delete'].invoke
      Rake::Task['dailyquest:data:load'].invoke
    end
    namespace :generate do
      task :types do
        make_types
      end
      task :simple_tasks do
        make_simple_tasks
      end
    end
  end

end


def make_types
  t = Task.new
  t.type = "Task"
  t.type = "Quest"
  t.type = "Questsequence"
end

def make_tasks_with_subtasks




end

# Create Tasks recursively by "walking through" the parsed YAML-Hash/Array construct
@named_tasks = {}
def make_task(task)
  new_task = []
  #If it is a simple task
  if task['for'].nil?
    #Create it
    if task['name']
      #If it has a name, store it
      new_task << Task.create(title: task['title'], description: task['description'], private: false, type: "Task", creator: 1)
      @named_tasks["#{task['name']}"] = new_task[-1] #Todo: Move this into an if in the else
    elsif task['named']
      #If it is a named task, retrieve it
      new_task << @named_tasks[task['named']]
    else
      # Just create a task
      new_task << Task.create(title: task['title'], description: task['description'], private: false, type: "Task", creator: 1)
    end
    unless task['subtasks'].nil?
      #Add subtasks if available
      task['subtasks'].each do |sub|
        new_task[-1].add_subtasks make_task(sub)
      end
    end
  else
    #If not simple
    range = eval("('#{task['for'][0]}'..'#{task['for'][2]}')")
    regex = /\#\{for\}/i
    #Create a task for each option in the range
    range.each do |nr|
      new_task << Task.create(title: task['title'].sub( regex, nr), description: task['description'].sub( regex, nr), private: false, type: "Task", creator: 1 )
    end
    #If there is are even deeper subtasks
    unless task['subtasks'].nil?
      task['subtasks'].each do |sub|
        #Get the created subs
        new_sub = make_task(sub)
        #Add them to each of the created "loop" tasks
        new_task.each do |t|
          t.add_subtasks new_sub
        end
      end
    end
  end
  return new_task
end

def make_simple_tasks
  tasks = YAML.load(File.read(File.expand_path('../tasks.yml', __FILE__)))
  tasks.each do |task|
    new_task = make_task(task)
  end
end

