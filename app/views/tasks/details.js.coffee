$('#right_content').html "<%= escape_javascript render partial: 'details_container', locals: { task: @task_detail, subs: true}   %>"
