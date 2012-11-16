# BasicCache object to store values
#
class BasicCache
  # Todo: Make the cache a class variable, not an instance variable, so that the cache is shared between the instances
  attr_reader :cache
  def initialize
    @cache = {}
  end

  delegate :[], :[]=, :key, :keys, :include?, :to_hash, to: :cache

  # Stores a value with a specific key
  #
  # * *Args*    :
  #   - +key+ -> The key to store the value with
  #   - +value+ -> The value to store
  # * *Returns* :
  #   - the value
  #
  def store(key, value)
    @cache[key] = value
  end

  # Retrieves a value by key
  #
  # * *Args*    :
  #   - +key+ -> The key to retrieve the value of
  # * *Returns* :
  #   - the value or nil
  #
  def get(key)
    @cache[key] || nil
  end

  # Tests equality between to BasicCaches
  #
  # * *Args*    :
  #   - +other+ -> The second BasicCache
  # * *Returns* :
  #   - Boolean indicating equality
  #
  def ==(other)
    self.keys.each do |key|
      unless other[key] == self[key]
        return false
      end
    end
    true
  end
end
