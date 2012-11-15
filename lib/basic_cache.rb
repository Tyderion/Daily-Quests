class BasicCache

  def initialize
    @cache = {}
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
end
