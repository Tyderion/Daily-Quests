require 'spec_helper'

describe SubtaskCache do
  before :each do
    @cache = SubtaskCache.new
    @task = FactoryGirl.build(:task)
    #debugger
    @task.save
    @cache.store(@task)
  end

  describe "store" do

    it "can store tasks" do
      expect { @cache.store(@task) }.to_not raise_error
    end
    it "returns the task when storing it" do
      @cache.store(@task).should == @task
    end
    it "cannot store other things than tasks" do
      @cache.store("@task").should == nil
    end
  end

  describe "get" do

    it "responds to get" do
    expect { @cache.get(@task.id) }.to_not raise_error
    end
    it "returns tasks by id" do
      @cache.get(@task.id).should == @task
    end
    it "returns nil if key not present" do
      @cache.get(0).should == nil
    end
  end
  describe "key" do

    it "returns the id of the task" do
      @cache.key(@task).should == @task.id
    end
    it "returns nil if value not present" do
      @cache.key("not_present").should == nil
    end
  end

  describe "include?" do
    it "returns true if key is in cache" do
      @cache.include?(@task.id).should == true
    end
    it "returns false if key is in not cache" do
      @cache.include?("note_present").should == false
    end
  end
end
