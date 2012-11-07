$ ->
  #this attaches to all pjax container
  $('select').chosen()
  #$('.pjax_container a').pjax('[data-pjax-container]')
  #$('input').pjax('[data-pjax-container]')


  $('html').on
    "ajax:error": (xhr, error) ->
      errormessages = $.parseJSON(error["responseText"])
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

  grandparent = $('#subtask_list').parent().parent()
  console.log grandparent
  $('#subtask_list').detach().appendTo(grandparent)


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
    connectToSortable: "#Target_sortable",
    helper: "clone",
    revert: "invalid"
  $('.sortable').sortable()
  $( ".sortable" ).disableSelection()
  $('.droppable').droppable
    drop: (event, ui) ->
      console.log $('img', ui.draggable).removeClass("hidden")
      console.log $('img', ui.draggable).removeClass("hidden")


  # $("html").pjax(".test a").on "pjax:success", (data, xhr, response) ->
  #   $.pjax
  #     url: $('.test a').val
  #     container: 'data-pjax-flash'

