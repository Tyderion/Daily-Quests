class BasicCache
  # Todo: Make the cache a class variable, not an instance variable, so that the cache is shared between the instances
  def initialize
    @cache = {}
  end

  def [](name)
    get(name)
  end
  def []=(name, value)
    store(name, value)
  end

  def store(key, value)
    @cache[key] = value
  end

  def get(key)
    @cache[key] || nil
  end

  def key(value)
    @cache.key(value) || nil
  end

  def include?(key)
    @cache.include? key
  end

  #Note: Do we really need this ?
  def cache
    @cache.dup
  end
end
