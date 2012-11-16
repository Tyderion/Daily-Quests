require 'cache/cache_shared_spec'
describe BasicCache do
  it_should_behave_like "cache",BasicCache, ->(){"value"}
end

