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

  it "has a valid factory" do
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
     should have_many(:questsequence)
  end



end
