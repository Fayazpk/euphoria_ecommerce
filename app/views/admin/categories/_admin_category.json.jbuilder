json.extract! admin_category, :id, :name, :description, :image, :created_at, :updated_at
json.url admin_category_url(admin_category, format: :json)
json.image url_for(admin_category.image)
