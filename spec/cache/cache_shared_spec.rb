require 'spec_helper'

shared_examples_for "cache" do |key_value_method|
  before :each do

    @key, @value = key_value_method.nil? ?  default_key_value : key_value_method.call
    store
  end

  def default_key_value(x = "")
    ["key#{x}", "value#{x}"]
  end

  def store( key= @key, value = @value)
    @arity ||= subject.method(:store).arity
    case @arity
    when 1
      subject.store(value)
    else
      subject.store(key, value)
    end
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
      store.should == @value
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
      subject.get(@key).should == @value
    end
    it "returns nil if key not present" do
      subject.get("not_present").should == nil
    end
  end
  describe "key" do
    it "returns the key to the corresponding value" do
      subject.key(@value).should == @key
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
      subject.include?(@key).should == true
    end
    it "returns false if key is in not cache" do
      subject.include?("key2").should == false
    end
  end


end
