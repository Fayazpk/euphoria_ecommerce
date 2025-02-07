class Usermodule::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_checkout, only: [:show, :update_address, :return_item]

  def index
    @orders = current_user.checkouts.includes(:order_items).order(created_at: :desc)
  end

  def show
    @order_items = @checkout.order_items.includes(:product)
  end

  def update_address
    if @checkout.can_update_address?
      if @checkout.update(checkout_params)
        redirect_to users_order_path(@checkout), notice: 'Address updated successfully'
      else
        render :edit_address
      end
    else
      redirect_to users_order_path(@checkout), alert: 'Address cannot be updated at this stage'
    end
  end

  def return_item
    order_item = @checkout.order_items.find(params[:order_item_id])
    if @checkout.can_return_items?
      order_item.return_item
      redirect_to users_order_path(@checkout), notice: 'Item return requested successfully'
    else
      redirect_to users_order_path(@checkout), alert: 'Item cannot be returned at this stage'
    end
  end

  private

  def set_checkout
    @checkout = current_user.checkouts.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "The requested checkout could not be found."
    redirect_to usermodule_checkouts_path
  end

  def checkout_params
    params.require(:checkout).permit(:address)
  end
end
