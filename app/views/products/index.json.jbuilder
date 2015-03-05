json.array!(@products) do |product|
  json.extract! product, :id, :type_id, :title, :intro, :low_price, :origin_price
  json.thumb_url root_url.chop + product.image_url(:thumb)
  json.large_url root_url.chop + product.image_url(:large)
  json.url product_url(product, format: :json)
end
