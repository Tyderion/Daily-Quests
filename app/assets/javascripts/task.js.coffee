$ ->
  $("html").on
    input: ->
      url = "/subtasks?search=#{@value}"
      $.getScript(url)
  ,"#search_tasks"
