class BasicCache
  # Todo: Make the cache a class variable, not an instance variable, so that the cache is shared between the instances
  attr_reader :cache
  def initialize
    @cache = {}
  end

  delegate :[], :[]=, :key, :keys, :include?, :to_hash, to: :cache

  def store(key, value)
    @cache[key] = value
  end

  def get(key)
    @cache[key] || nil
  end

  def ==(other)
    self.keys.each do |key|
      unless other[key] == self[key]
        return false
      end
    end
    true
  end
end
