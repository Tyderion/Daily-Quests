require 'spec_helper'

describe TaskService do

  before :each do
    @titles = ["Should not be found","Search term anywhere", "Search term is where we look","Where is the term?" ]
    @term = "whe"
    @tasks = []
    @titles.each do |title|
      @tasks << FactoryGirl.create(:task, title: title )
    end
    # Define Mock-class with a where function passing the arguments on to the task Where
    @class = Class.new{ def self.where(*args); Task.where(args); end }.extend(TaskService)
  end


  describe "search_by_title" do
    it "returns an array of tasks containing the search title" do
      @class.search_by_title(@term).map{|ta| ta.title }.should == @titles[1,3]
    end
  end

  describe "sort_by" do
    it "first are titles that begin with the search term" do
      @class.sort_by(@tasks[1,3], @term)[0].title.should == @titles[3]
    end
    it "second are titles that have a word that begins with the search term" do
      @class.sort_by(@tasks[1,3], @term)[1].title.should == @titles[2]
    end
    it "third are titles that have the term anywhere" do
      @class.sort_by(@tasks[1,3], @term)[2].title.should == @titles[1]
    end
    it "is the same size as the array passed in" do
      @class.sort_by(@tasks[1,3], @term).length.should == @tasks[1,3].length
    end
  end


end
