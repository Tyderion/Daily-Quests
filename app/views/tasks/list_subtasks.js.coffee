$('#subtasks_list').remove()
$('#left_content').append "<%= escape_javascript render partial: 'subtasks_list' %>"
