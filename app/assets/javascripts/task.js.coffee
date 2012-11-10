$ ->
  $("html").on
    input: ->
      url = "/subtasks?search=#{@value}"
      console.log url
      $.getScript(url)
  ,"#search_tasks"
