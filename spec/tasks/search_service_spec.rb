require 'spec_helper'

describe SearchService do

  before :each do
    @titles = ["Should not be found","Search term anywhere", "Search term is where we look","Where is the term?" ]
    @term = "whe"
    @tasks = []
    @titles.each do |title|
      @tasks << FactoryGirl.create(:task, title: title )
    end
    # Define Mock-class with a where function passing the arguments on to the task Where
    @class = Class.new{ def self.where(*args); Task.where(args); end }.extend(SearchService)
    #Testing with the same query the search_by_title should build
    @hash  = {query: "title LIKE ? and private = ?", arguments: ["%whe%", false] }
  end


  describe "search_by_title" do
    it "returns an array of tasks containing the search title" do
      @class.search_by_title(@term).map{|ta| ta.title }.should == @titles[1,3]
    end
  end

  describe "build_query (for a where-select)" do
    #Todo: More Failing Tests
    before :each do
      @result_hash = @class.build_query(:"title LIKE" => "%whe%",:"private =" => false)
    end
    it "builds a query from a hash" do
      @result_hash.should == @hash
    end
    it "returns a query in key :query" do
      @result_hash[:query].should == @hash[:query]
    end
    it "returns the arguments in key :arguments" do
      @result_hash[:arguments].should == @hash[:arguments]
    end
    it "has the same amount of ? in the query as arguments" do
      @result_hash[:query].scan('?').length.should == @hash[:arguments].length
    end
    it "creates invalid query for invalid input" do
      fail = @class.build_query(title: "%whe%",private:  false)
      fail[:query].scan('?').length.should == @hash[:arguments].length
    end
  end

  describe "search" do
    it "search for the query with arguments passed to it" do
      result = @class.search(@hash).map{|t| t.title }
      result.should == @titles[1,3]
    end
  end
end
