require 'spec_helper'

shared_examples_for "cache" do |cache, value_method|
  before :each do
    @cache = cache.new
    @value = value_method
    @key = "key"
    @cache.store(@key, @value)
  end



  describe "store" do

    it "responds to store" do
    expect { @cache.store(@key, @value) }.to_not raise_error
    end
    it "returns the thing when storing it" do
      @cache.store(@key, @value).should == @value
    end
  end

  describe "cache" do
    it "returns a hash" do
      @cache.cache.class.should == Hash
    end
    it "contains the values" do
      @cache.cache[@key] = @value
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
    it "returns true if key is in cache" do
      @cache.include?(@key).should == true
    end
    it "returns false if key is in not cache" do
      @cache.include?("key2").should == false
    end
  end


end
