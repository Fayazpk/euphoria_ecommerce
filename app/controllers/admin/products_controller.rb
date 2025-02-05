class Admin::ProductsController < ApplicationController
  layout 'admin'
  before_action :set_admin_product, only: %i[show edit update destroy]
  before_action :load_categories_and_subcategories, only: %i[new edit create update]

  def index
    @admin_products = Product.order(created_at: :desc)
  end

  def show
  end

  def new
    @admin_product = Product.new
    build_variants_for_sizes
  end

  def edit
    build_variants_for_sizes if @admin_product.product_variants.empty?
  end

  def create
    @admin_product = Product.new(admin_product_params)
    if @admin_product.save
      process_images if params[:product][:images].present?
      redirect_to admin_products_path, notice: "Product was successfully created."
    else
      build_variants_for_sizes
      render :new, status: :unprocessable_entity
    end
  end

  def update
    delete_images if params[:product][:delete_images].present?
    if @admin_product.update(admin_product_params)
      process_images if params[:product][:images].present?
      redirect_to admin_product_path(@admin_product), notice: "Product was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @admin_product.destroy!
    redirect_to admin_products_path, notice: "Product was successfully deleted.", status: :see_other
  end

  private

  def set_admin_product
    @admin_product = Product.find(params[:id])
  end

  def load_categories_and_subcategories
    @categories = Category.all
    @subcategories = Subcategory.all
  end

  def admin_product_params
    params.require(:product).permit(
      :name, :description, :category_id, :subcategory_id, :base_price, :discount_percentage, :total_price,
      { images: [] }, { delete_images: [] },
      product_variants_attributes: [:id, :size_id, :stock, :_destroy]
    )
  end

  def process_images
    params[:product][:images].each do |uploaded_file|
      if uploaded_file.respond_to?(:content_type) && uploaded_file.content_type.start_with?("image/")
        @admin_product.images.attach(uploaded_file)
      end
    end
  end

  def delete_images
    params[:product][:delete_images].each do |image_id|
      image = @admin_product.images.find_by(id: image_id)
      image&.purge
    end
  end

  def build_variants_for_sizes
    Size.all.each do |size|
      @admin_product.product_variants.build(size: size) unless @admin_product.product_variants.any? { |v| v.size == size }
    end
  end
end
