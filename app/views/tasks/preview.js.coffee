$('#right_content').html "<%= escape_javascript render partial: 'details_container' %>"

$('li.toggle', '#right_content').append "<%= escape_javascript render partial: 'preview_subtasks' %>"
$('#right_content > div > div > h2').html "<%= t('task.preview.title') %>"
