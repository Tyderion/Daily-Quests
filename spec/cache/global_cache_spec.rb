require 'cache/cache_shared_spec'

describe GlobalCache do
  it_should_behave_like "cache"
  before :each do
    @key, @value = ["key", "value"]
    @instance_key = 1
  end
  it "returns the same saved values if creating with a key" do
    g1 = GlobalCache.new(key: @instance_key)
    g1.store(@key, @value)
    g2 = GlobalCache.new(key: @instance_key)
    g2.should == g1
  end
end
