# GlobalCache inheriting from BasicCache implementing a global cache.
# Instance-caches are stored in the global cache
#
class GlobalCache < BasicCache
  # Initializes the GlobalCache-Object
  #
  # * *Args*    :
  #   - +key:+ -> the Key to store the local hash in the global hash, default: SecureRandom.uuid
  #   - +cache:+ -> A Cache-like object to use as local cache
  # * *Returns* :
  #   - A new GlobalCache
  #
  def initialize(*args)
    super()
    options = args.extract_options!
    @@global_cache ||= {}
    @key = options[:key] || SecureRandom.uuid
    if options[:cache].nil?
      @cache = @@global_cache[@key] || BasicCache.new
     else
      @cache = @@global_cache[@key] || options[:cache].new
    end
    @@global_cache[@key] = @cache
  end

  # Removes the saved values from the global hash, can still store/retrieve values.
  #
  def localize
    @@global_cache.delete @key
  end



end
