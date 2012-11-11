$('#right_content').html "<%= escape_javascript render partial: 'details_container' %>"
$('#center_content').html "<%= escape_javascript render partial: 'form' %>"
$('#left_content').html "<%= escape_javascript render partial: 'left_content' %>"
document.title =  "<%= t('task.new') %>"
console.log $('#task_type_chzn > a > span').html "<%= @task.type %>"

$('#center_content').prepend "<h1> <%= t('task.edit') %> </h1>"
$('#subtasks_list').height $(window).height()*2/3
$('.draggable').draggable
  connectToSortable: "#subtask_sortable",
  helper: "clone",
  revert: "invalid"
$('#subtask_list > ol >  li').each (iindex, element)->
  window.subtask_dropped element
$('.sortable').sortable()
$( ".sortable" ).disableSelection()
$('.droppable').droppable
  drop: (event, ui) ->
    console.log $('img', ui.draggable).removeClass("hidden")
    console.log $('.ui-icon-arrowthick-1-e', ui.draggable).hide()
$('select').chosen()

$('#task_type_chzn > a > span').html "<%= @task.type %>"
$('#task_type_chzn > a > span').css "color", "black"
$(e).addClass('resul-selected') for e in $('#task_type_chzn > div > ul.chzn-results > li') when e.html() == "<%= @task.type %>"


