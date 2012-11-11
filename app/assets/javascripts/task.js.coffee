$ ->
  $('#subtasks_list').height $(window).height()*2/3
  $("html").on
    input: ->
      url = "/subtasks?search=#{@value}"
      $.getScript(url)
  ,"#search_tasks"
  $('html').on
    click: ->
      subtasks = []
      $('#subtask_sortable > li').each (i, e) ->
        subtasks.push $('input', e).val()
      $.ajax
        url: '/task/preview'
        type: "get"
        dataType: 'script'
        data:
          task:
            title: $('#task_title').val()
            description: $('#task_description').val()
            private: $('#task_private_input > input').val()
            type: $('#task_type_chzn > a > span').html()
            subtasks: subtasks


  , "#task_preview_action"
  $('html').on
    click: ->
      element = $(this).closest('li').clone()
      window.subtask_dropped element
      $('#subtask_sortable').append element

  , ".subtask > .ui-icon-arrowthick-1-e"
  $('html').on
    click: ->
      $.getScript $('a', this).attr 'href'

  , ".subtask > .ui-icon-wrench"


  window.timer = 0
  # $(window).on
  #   resize: ->
  #     #As long as we're resizing, do not resize the list
  #     $.debounce 250, ->
  #       console.log "bounced...!"
  #       $('#subtasks_list').height $(window).height()*2/3

  $(window).resize $.debounce 250, ->
    $('#subtasks_list').height $(window).height()*2/3




  $('select').chosen()
  #$('.pjax_container a').pjax('[data-pjax-container]')
  #$('input').pjax('[data-pjax-container]')


  $('html').on
    "ajax:error": (xhr, error) ->
      errormessages = $.parseJSON $.parseJSON(error["responseText"]).errors
      subtasks = $.parseJSON(error["responseText"]).subtasks
      console.log subtasks
      $('.inline_error').remove()
      $('label[for^="task"]').css "color", "black"

      $.each errormessages, (index, value) ->
        add_error
          title: index
          error: value

  , "#new_task"

  $('html').on
    click: ->
      $(this).closest('li').remove()
  , "#delete_icon"

  add_error= (error) ->
    li_element = $("#task_#{error["title"]}_input")
    $('label', li_element).css "color", "red"
    $(li_element).append "<div class='inline_error'> #{error["error"]} </div>"



  $('html').on
    click: ->
      console.log $(this).parent().next()
      console.log $(this).parent().next().attr('class')
      if $(this).parent().next().attr('class') == "toggle"
        $(this).parent().next().toggle()
  , ".triangle"

  $('html').on
    click: ->
      $(this).parent().remove()
  , '.remove'

  $('.draggable').draggable
    connectToSortable: "#subtask_sortable",
    helper: "clone",
    revert: "invalid"
  $('.sortable').sortable()
  $( ".sortable" ).disableSelection()
  $('.droppable').droppable
    drop: (event, ui) ->
      window.subtask_dropped  ui.draggable

  window.subtask_dropped = (ui) ->
    $('img', ui).removeClass("hidden")
    $('.ui-icon-arrowthick-1-e', ui).hide()

