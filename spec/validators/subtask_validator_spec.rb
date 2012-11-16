require 'spec_helper'

describe SubtaskValidatorWithCache do
  #Todo: Specs for the validator
  before :each do
      @task = FactoryGirl.create(:task)
      @task2 = FactoryGirl.create(:task)
      @task_validator = SubtaskValidatorWithCache.new(@task)
      @task2_validator = SubtaskValidatorWithCache.new(@task2)
  end
  it "an unrelated task is a valid subtask" do
    @task_validator.valid?(@task2).should == true
  end
  it "a task itself is an invalid subtask" do
    @task_validator.valid?(@task).should == false
  end
  it "is not possible to add a parent of itself to itself" do
    @task.add_subtask(@task2)
    @task2_validator.valid?(@task).should == false
  end
  it "an ancestor is not valid" do
    @task.add_subtask(@task2)
    @task2_validator.valid?(@task).should == false
  end
  it "an ancestor is not valid after being tested when valid" do
    @task2_validator.valid?(@task)
    @task.add_subtask(@task2)
    @task2_validator.valid?(@task).should == false
  end
  it "is not possible to add any ancestor way back to a task" do
      tasks = []
      #Creating 10 tasks
      (1..10).each {tasks << FactoryGirl.create(:task)}
      #Creating a validator for the last one
      validator = SubtaskValidatorWithCache.new( tasks[-1])
      if validator.valid?(@task) #Validating to add to cache an be sure it works as intended
        task = @task
        tasks.each do |t|
          t.save
          task.add_subtask(t)
          task = t
        end
      end
      #Now it should be invalid
      validator.valid?(@task).should == false
    end
end
