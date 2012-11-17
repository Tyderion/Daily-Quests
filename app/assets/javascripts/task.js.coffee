$ ->
  $('#subtasks_list').height $(window).height()*2/3
  $("html").on
    input: ->
      url = "/search_subtasks_list?search=#{@value}"
      $.getScript(url)
  ,"#search_tasks"
  $('html').on
    click: ->
      subtasks = []
      $('#subtask_sortable > li').each (i, e) ->
        subtasks.push $('input', e).val()

      # if $('#task_id').val() > 0
      #   $.ajax
      #     url: '/task/preview'
      #     type: "get"
      #     dataType: 'script'
      #     data:
      #       task:
      #         id: $('#task_id').val()
      #         subtasks: subtasks
      # else
      $.ajax
        url: '/task/preview'
        type: "get"
        dataType: 'script'
        data:
          task:
            id: $('#task_id').val()
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
      window.adjust_inputs()

  , ".subtask > .ui-icon-arrowthick-1-e"
  $('html').on
    click: ->
      $.getScript $('a', this).attr 'href'

  , ".subtask > .ui-icon-wrench"


  window.timer = 0

  $(window).resize $.debounce 250, ->
    $('#subtasks_list').height $(window).height()*2/3

  window.adjust_inputs= ->
    $('input', e).attr('id', "subtask#{$(e).index()}") for e in $('#subtask_sortable >  li')
    $('input', e).attr('name', "task[subtasks[#{$(e).index()}]]") for e in $('#subtask_sortable >  li')



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
    element = $("#task_#{error["title"]}").parent()
    $(element).append "<div class='inline_error'> #{error["error"]} </div>"
    $('.inline_error').css "color", "red"


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
  $('.sortable').sortable
    update: (event, ui) ->
      adjust_inputs()
  $( ".sortable" ).disableSelection()
  $('.droppable').droppable
    drop: (event, ui) ->
      window.subtask_dropped  ui.draggable
      adjust_inputs()

  window.subtask_dropped = (ui) ->
    $('img', ui).removeClass("hidden")
    $('.ui-icon-arrowthick-1-e', ui).hide()
  window.adjust_inputs()

