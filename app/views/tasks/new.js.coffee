$('#right_content').html "<%= escape_javascript render partial: 'details_container' %>"
$('#center_content').html "<%= escape_javascript render partial: 'form' %>"
$('#subtasks_list').remove()
$('#left_content').append "<%= escape_javascript render partial: 'subtasks_list' %>"
console.log $('#subtask_list')

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
$('select').chosen()

