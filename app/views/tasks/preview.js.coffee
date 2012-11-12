
$('#right_content').html "<%= escape_javascript render partial: 'details_container', locals: {subs: false} %>"

$('li.toggle', '#right_content').append "<%= escape_javascript render partial: 'preview_subtasks' %>"
$('li.toggle', '#right_content').first().css "display", "inline"
$('#right_content > div > div > h2').html "<%= t('task.preview.title') %>"
errors = "<%= @invalid_subtasks.to_json %>"
console.log errors
$("#subtask_sortable > li > label > span.inline_error").remove()
$('label', $("#subtask_sortable > li > input[value='#{e}']").parent()).append("<span class='inline_error' style> <%= t('task.invalid_subtask')%> </span>") for e in errors

