json.array!(@apartments) do |apartment|
  json.extract! apartment, :id, :name, :address
  json.image_url root_url.chop + apartment.image_url
end
