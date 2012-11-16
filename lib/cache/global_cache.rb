class GlobalCache < BasicCache
  def initialize(*args)
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
