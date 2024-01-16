json.status 201
json.attachment do
  json.id @attachment.id
  json.todo_id @attachment.todo_id
  json.file do
    json.url url_for(@attachment.file)
    json.filename @attachment.file.filename.to_s
  end
  json.created_at @attachment.created_at.iso8601
end
