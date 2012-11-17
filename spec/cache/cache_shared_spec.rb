require 'spec_helper'

def default_key_value(x = "")
  ["key#{x}", "value#{x}"]*2
end

def store( key= @key, value = @value, cache = subject )
  arity = cache.method(:store).arity
  case arity
  when 1
    cache.store(value)
  else
    cache.store(key, value)
  end
end

shared_examples_for "cache" do |key_value_method|
  before :each do
    @key, @value, @retrieve_key, @stored_value = key_value_method.nil? ?  default_key_value : key_value_method.call
    store
  end
  describe "equality" do
    it "is equal if the key/value pairs are equal" do
      @cache = subject.dup
      subject.should == @cache
    end
  end

  describe "store" do

    it "responds to store" do
    expect { store }.to_not raise_error
    end
    it "returns the thing when storing it" do
      store.should == @stored_value
    end
  end

  describe "to_hash" do
    it "returns a Hash containing the key-value pairs" do
      subject.to_hash.class.should == Hash
    end
    it "contains the values" do
      subject.to_hash[@key] = @value
    end
  end


  describe "get" do
    it "responds to get" do
    expect { subject.get(@key) }.to_not raise_error
    end
    it "returns things" do
      subject.get(@key).should == @stored_value
    end
    it "returns nil if key not present" do
      subject.get("not_present").should == nil
    end
  end
  describe "key" do
    it "returns the key to the corresponding value" do
      subject.key(@stored_value).should == @key
    end
     it "returns nil if value not present" do
      subject.key("not_present").should == nil
    end
  end
  describe "keys" do
    it "returns an array" do
      subject.keys.class.should == Array
    end
    it "contains the keys" do
      subject.keys[0] = @key
    end
  end

  describe "include?" do
    it "returns true if key is in cache" do
      subject.include?(@retrieve_key).should == true
    end
    it "returns false if key is in not cache" do
      subject.include?("key2").should == false
    end
  end
end

shared_examples_for "global-cache" do |key_value_retrieve_method|
  it_should_behave_like "cache", key_value_retrieve_method
  before :each do
    @key, @value = key_value_retrieve_method.nil? ?  default_key_value : key_value_retrieve_method.call
    #@retrieve_key, @stored_value = retrieve_method.nil? ?  retrieve_method : retrieve_method.call
    @instance_key = 1
  end
  it "returns the same saved values if creating with a key" do
    g1 = subject.class.new(key: @instance_key)
    store(@key, @value, g1)
    g2 = subject.class.new(key: @instance_key)
    g2.should == g1
  end
end
