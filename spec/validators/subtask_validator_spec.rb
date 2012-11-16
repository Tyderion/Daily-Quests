require 'spec_helper'

describe SubtaskValidatorWithCache do
  #Todo: Specs for the validator
  before :each do
    @task = FactoryGirl.create(:task)
    @task2 = FactoryGirl.create(:task)
    @task_validator = SubtaskValidatorWithCache.new(@task)
    @task2_validator = SubtaskValidatorWithCache.new(@task2)
  end
  describe "valid?"  do
    it "returns true if it is an unrelated task" do
      @task_validator.valid?(@task2).should == true
    end
    it "returns false if it is the same task" do
      @task_validator.valid?(@task).should == false
    end
    it "returns false if it is an ancestor" do
      @task.add_subtask(@task2)
      @task2_validator.valid?(@task).should == false
    end
    context "been tested before" do
      it "returns true the first time"  do
        @task2_validator.valid?(@task).should == true
      end
      it "returns false if the task is now an ancestor" do
      @task2_validator.valid?(@task)
      @task.add_subtask(@task2)
      @task2_validator.valid?(@task).should == false
      end
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
    context "type" do
      before :each do
        @quest = FactoryGirl.create(:task, type_id: 2)
        @quest_validator = SubtaskValidatorWithCache.new(@quest)
        @questsequence = FactoryGirl.create(:task, type_id: 3)
        @questsequence_validator = SubtaskValidatorWithCache.new(@quest)
      end
      context "Task" do
        it "returns true if other is type task" do
          #debugger
          @task_validator.valid?(@task2).should == true
        end
        it "returns false if other is type quest" do
          @task_validator.valid?(@quest).should == false
        end
        it "returns false if other is type questsequence" do
          @task_validator.valid?(@questsequence).should == false
        end
      end
      context "Quest" do
        it "returns true if other is type task" do
          @quest_validator.valid?(@task2).should == true
        end
        it "returns false if other is type quest" do
          @quest_validator.valid?(@quest).should == false
        end
        it "returns false if other is type questsequence" do
          @quest_validator.valid?(@questsequence).should == false
        end
      end
      context "Questsequence" do
        it "returns false if other is type task" do
          @questsequence_validator.valid?(@task2).should == true
        end
        it "returns true if other is type quest" do
          @questsequence_validator.valid?(@quest).should == false
        end
        it "returns false if other is type questsequence" do
          @questsequence_validator.valid?(@questsequence).should == false
        end
      end
    end
  end
end
