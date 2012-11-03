require 'spec_helper'

describe Task do
  before :each do
    @task = FactoryGirl.create(:task)
  end


  describe "the description" do
    it "should be called description" do
      should respond_to :description
    end
    it "should be validated for presence" do
      should validate_presence_of :description
    end
  end

  describe "the title" do
    it "should respond to title" do
      should respond_to :title
    end

    it "title should be validated for presence" do
      should validate_presence_of :title
    end
  end
  describe "the creator" do
    it "should respond to creator" do
      should respond_to :creator
    end
    it "creator should be validated for presence" do
      should validate_presence_of :creator
    end
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
    should respond_to :typ
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
