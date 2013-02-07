require 'factory_girl'

FactoryGirl.define do
  factory :task do
    sequence(:description)  { |n| "Description #{n}: A Nice Task Number #{n}" }
    sequence(:title) { |n| "Title #{n}" }
    private false
    type "Task"
    creator 1 # First User creates all
  end

  trait :quest do
    type "Quest"
  end
  trait :questsequence do
    type "Questsequence"
  end

  # factory :subtask do
  #   association :task, factory: :task
  #   association :subtask, factory: :task
  # end
  # factory :quest do
  #   association :task, factory: :task, type: TaskType.id_for("Task")
  #   association :quest, factory: :task, type: TaskType.id_for("Quest")
  # end
  # factory :questsequence do
  #   association :quest, factory: :task, type: TaskType.id_for("Quest")
  #   association :questsequence, factory: :task, type: TaskType.id_for("Questsequence")
  # end
end
