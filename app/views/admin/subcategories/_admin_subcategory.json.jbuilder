json.extract! admin_subcategory, :id, :name, :description, :category_id, :image, :created_at, :updated_at
json.url admin_subcategory_url(admin_subcategory, format: :json)
json.image url_for(admin_subcategory.image)
