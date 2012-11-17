module SortService
  @@begins_with = Proc.new {|s| /^#{s}.*$/i }
  @@word_begins_with = Proc.new {|s| /^.* #{s}.*$/i }

  def sort_by_title(items, term)
    first = items.find_all{|item| item.title =~ @@begins_with.call(term) }
    second = items.find_all{|item| item.title =~ @@word_begins_with.call(term) }
    last = items.to_a - first - second
    first + second + last
  end
end
