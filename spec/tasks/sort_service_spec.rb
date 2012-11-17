require 'spec_helper'


describe SortService do
  before :each do
    @titles = ["Should not be found","Search term anywhere", "Search term is where we look","Where is the term?" ]
    @term = "whe"
    @tasks = []
    @titles.each do |title|
      @tasks << FactoryGirl.create(:task, title: title )
    end
    # Define Mock-class with a where function passing the arguments on to the task Where
    @class = Class.new.extend(SortService)
  end
  describe "sort_by_title" do
    it "first are titles that begin with the search term" do
      @class.sort_by_title(@tasks[1,3], @term)[0].title.should == @titles[3]
    end
    it "second are titles that have a word that begins with the search term" do
      @class.sort_by_title(@tasks[1,3], @term)[1].title.should == @titles[2]
    end
    it "third are titles that have the term anywhere" do
      @class.sort_by_title(@tasks[1,3], @term)[2].title.should == @titles[1]
    end
    it "is the same size as the array passed in" do
      @class.sort_by_title(@tasks[1,3], @term).length.should == @tasks[1,3].length
    end
  end
end
