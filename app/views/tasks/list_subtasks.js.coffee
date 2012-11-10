$('#left_content').html "<%= escape_javascript render partial: 'subtasks_list' %>"
$('#search_tasks').focus().caretToEnd()
