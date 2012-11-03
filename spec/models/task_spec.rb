require 'spec_helper'

describe Task do
  before :each do
    @task = FactoryGirl.create(:task)
  end

  it "should have a description" do
    should respond_to :description
  end
  it "should respond to title" do
    should respond_to :title
  end

  it "should respond to private" do
    should respond_to :private
  end
  it "should respond to private?" do
    expect { @task.private? }.to_not raise_error
  end

  it "should respond to public?" do
    expect { @task.public? }.to_not raise_error
  end
  it "should have a type" do
    should respond_to :type
  end
  it "should have many Subasks " do
    should have_many(:subtasks)
  end

  it "should have many Quests" do
     should have_many(:quests)
  end

  it "should have many Questsequence" do
     should have_many(:questsequence)
  end



end
