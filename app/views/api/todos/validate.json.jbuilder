json.status @status

if @status == 200
  json.message "No conflicts found."
else
  json.error @error_message
