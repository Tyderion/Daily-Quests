$('#subtasks_list').remove()
$('#left_content').append "<%= escape_javascript render partial: 'subtasks_list' %>"
$('#subtasks_list').height $(window).height()*2/3
