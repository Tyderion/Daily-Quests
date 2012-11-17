module SearchService
  def search_by_title(term)
    options = {}
    options["title LIKE"] = "%#{term}%"
    options["private ="] = false
    search(build_query(options))
  end


  def build_query(*args)
    options = args.extract_options!
    query= ""
    arguments = []
    options.each_with_index do |key_value, index|
      key, value = key_value
      query += "#{key} ?"
      if index < options.size - 1
        query += " and "
      end
      arguments << value
    end
    {query: query, arguments: arguments}
  end


  def search(*args)
    options = args.extract_options!
    self.where(options[:query], *options[:arguments])
  end
end
