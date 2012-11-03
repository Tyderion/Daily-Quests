require 'factory_girl'

FactoryGirl.define do
  factory :task do
    sequence(:description)  { |n| "Description #{n}"+Faker::Lorem.paragraph }
    type TaskType.id_for "Task"
  end

  factory :subtask do
    association: :task, factory: :task, type: TaskType.id_for "Task"
    association: :subtask, factory: :task, type: TaskType.id_for "Task"
  end
  factory :quest do
    association: :task, factory: :task, type: TaskType.id_for "Task"
    association: :quest, factory: :task, type: TaskType.id_for "Quest"
  end
  factory :questsequence do
    association: :quest, factory: :task, type: TaskType.id_for "Quest"
    association: :questsequence, factory: :task, type: TaskType.id_for "Questsequence"
  end
end
