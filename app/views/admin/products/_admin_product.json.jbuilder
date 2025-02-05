json.extract! admin_product, :id, :name, :description, :base_price, :category_id, :subcategory_id, :images, :created_at, :updated_at
json.url admin_product_url(admin_product, format: :json)
json.images do
  json.array!(admin_product.images) do |image|
    json.id image.id
    json.url url_for(image)
  end
end
