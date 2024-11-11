class ProductsController < ApplicationController

  before_action :load_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product, notice: "Product is successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: "Product is successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
  end

  def destroy
    @product.destroy
    redirect_to products_path, status: :see_other, notice: "Product is successfully deleted."
  end

  private

  def load_product
    @product = Product.find_by(id: params[:id])
    redirect_to products_path, notice: "Product not found." unless @product
  end

  def product_params
    params.require(:product).permit(:name, :description)
  end
end