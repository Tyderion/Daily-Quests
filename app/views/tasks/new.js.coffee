$('#right_content').html "<%= escape_javascript render partial: 'details_container' %>"
$('#center_content').html "<%= escape_javascript render partial: 'form' %>"
$('#left_content').prepend "<%= escape_javascript render partial: 'subtasks_list' %>"
#$('#inner').prepend "<%= escape_javascript render partial: 'details_container' %>"
console.log $('#subtask_list')
grandparent = $('#subtask_list').parent().parent()
console.log grandparent
$('#subtask_list').detach().appendTo(grandparent)
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

