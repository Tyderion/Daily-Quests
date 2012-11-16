# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  private     :boolean
#  creator     :integer
#  type        :integer
#

require 'spec_helper'

describe Task do

  it "has a valid factory (factory doesn't always work in this test Oo)" do
    FactoryGirl.create(:task).should be_valid
  end


  it "is invalid without a description" do
    FactoryGirl.build(:task, description: nil).should_not be_valid
  end
  it "is invalid without a title" do
    FactoryGirl.build(:task, title: nil).should_not be_valid
  end
  it "is invalid without a Visiblity" do
    FactoryGirl.build(:task, private: nil).should_not be_valid
  end
  it "has type 'Task' if none is set" do
    FactoryGirl.build(:task, type: nil).type.should == "Task"
  end

  it "is invalid without a creator" do
    FactoryGirl.build(:task, creator: nil).should_not be_valid
  end


  describe "Subtasks" do
    before :each do
      @task = FactoryGirl.create(:task)
    end
    it "is possible to add a task to another task as a subtask" do
      task2 = FactoryGirl.create(:task)
      @task.add_subtask(task2)
      @task.subtasks.length.should == 1
    end
    it "is not possible to add a task to itself" do
      @task.subtask_valid?(@task).should == false
    end
    it "is not possible to add a parent of itself to itself" do
      task2 = FactoryGirl.create(:task)
      @task.add_subtask(task2)
      task2.subtask_valid?(@task).should == false
    end
    it "is not possible to add any ancestor to a task" do
      tasks = []
      (1..10).each {tasks << FactoryGirl.create(:task)}
      task = @task
      tasks.each do |t|
        p "#{t} is #{task.valid?}"
        t.save
        task.add_subtask(t)
        task = t
      end
      p @task.subtasks
      tasks.each do |t|
        p t.subtasks
      end
      tasks[-1].subtask_valid?(@task).should == false
    end
  end

  describe "Visibility " do
    before :each do
      @task = FactoryGirl.create(:task)
    end
    it "responds to private?" do
      expect { @task.private? }.to_not raise_error
    end

    it "responds to public?" do
      expect { @task.public? }.to_not raise_error
    end
  end

  it "has many Subasks " do
    should have_many(:subtasks)
  end

  it "has many Quests" do
     should have_many(:quests)
  end

  it "has many Questsequences" do
     should have_many(:questsequences)
  end



end
