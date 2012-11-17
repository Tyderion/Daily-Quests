$('.rightbar').html "<%= escape_javascript render partial: 'details_container', locals: {task: @task} %>"
