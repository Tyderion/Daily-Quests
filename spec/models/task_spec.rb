require 'spec_helper'

describe Task do

  it "should have a description" do
    should respond_to :description
  end
  it "should have a type" do
    should respond_to :type
  end
  it "should have many Subasks as Subtasks" do
    should have_many(:subtasks)
  end

  it "should have many Tasks as Quests" do
     should have_many(:quests)
  end

  it "should have many Tasks as Questseries" do
     should have_many(:questseries)
  end

end
