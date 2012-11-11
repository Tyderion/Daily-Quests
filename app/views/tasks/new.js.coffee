$('#right_content').html "<%= escape_javascript render partial: 'details_container' %>"
$('#center_content').html "<%= escape_javascript render partial: 'form' %>"
$('#left_content').html "<%= escape_javascript render partial: 'left_content' %>"
document.title =  "<%= t('task.new') %>"
$('#center_content').prepend "<h1> <%= t('task.new') %> </h1>"
console.log $('#subtask_list')
$('#subtasks_list').height $(window).height()*2/3
$('.draggable').draggable
  connectToSortable: "#subtask_sortable",
  helper: "clone",
  revert: "invalid"
$('.sortable').sortable()
$( ".sortable" ).disableSelection()
$('.droppable').droppable
  drop: (event, ui) ->
    console.log $('img', ui.draggable).removeClass("hidden")
    console.log $('.ui-icon-arrowthick-1-e', ui.draggable).hide()
$('select').chosen()


