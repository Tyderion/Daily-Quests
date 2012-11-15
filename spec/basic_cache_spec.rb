require 'spec_helper'

describe BasicCache do
  before :each do
    @cache = BasicCache.new
    @value = "value"
      @key = "key"
      @cache.store(@key, @value)
  end

  describe "store" do
    it "responds to store" do
    expect { @cache.store("key", "thing") }.to_not raise_error
    end
    it "returns the thing when storing it" do
      value = "thing"
      key = "key"
      @cache.store(key, value).should == value
    end
  end

  describe "get" do
    it "responds to get" do
    expect { @cache.get(@key) }.to_not raise_error
    end
    it "returns things" do
      @cache.get(@key).should == @value
    end
    it "returns nil if key not present" do
      @cache.get("not_present").should == nil
    end
  end
  describe "key" do
    it "returns keys" do
      @cache.key(@value).should == @key
    end
     it "returns nil if value not present" do
      @cache.key("not_present").should == nil
    end
  end

  describe "include?" do
    before :each do
      @value = "thing"
      @key = "key"
      @cache.store(@key, @value )
    end
    it "returns true if key is in cache" do
      @cache.include?(@key).should == true
    end
    it "returns false if key is in not cache" do
      @cache.include?("key2").should == false
    end
  end


end
