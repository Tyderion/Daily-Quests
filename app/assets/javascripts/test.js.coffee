$ ->
  #this attaches to all pjax container
  $('select').chosen()
  #$('.pjax_container a').pjax('[data-pjax-container]')
  #$('input').pjax('[data-pjax-container]')



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


  $('html').on
    click: (event) ->
      console.log event
      console.log $('#Subtask_New option:selected').html()
      $('.subtasks ol').append "<li><span class='remove'>x</span>
          <label for='subtask#{$('.subtasks ol li').length}'>
          <a data-remote='true' href='/tasks/new?task_id=#{$('#Subtask_New option:selected').val()}' > #{$('#Subtask_New option:selected').html()}  </a>
            </label>
          <input id='subtask#{$('.subtasks ol li').length}' type='hidden'
            name=task[subtasks[#{$('.subtasks ol li').length}]] value='#{$('#Subtask_New option:selected').val()}'>
          </li>"
  , '#Subtask_New_chzn div ul .active-result'

  # $("html").pjax(".test a").on "pjax:success", (data, xhr, response) ->
  #   $.pjax
  #     url: $('.test a').val
  #     container: 'data-pjax-flash'

