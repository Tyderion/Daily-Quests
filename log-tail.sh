tail -f -n 50 log/development.log | grep -v 'Started GET' | grep -v 'Served asset' | grep -v '^$'

