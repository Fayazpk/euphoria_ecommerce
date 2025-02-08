module Usermodule
  class OrdersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_order, only: [:show, :update_address, :return_item, :track]

    def index
      @orders = current_user.orders
                          .includes(:order_items, :address)
                          .order(created_at: :desc)
                          .page(params[:page])
    end

    def show
      @return_requests = @order.return_requests.includes(:order_item)
    end

    def track
      @status_histories = @order.order_status_histories.includes(:changed_by)
    end

    def update_address
      if @order.can_update_address?
        if @order.update(address_params)
          flash[:notice] = 'Delivery address updated successfully.'
        else
          flash[:alert] = 'Failed to update delivery address.'
        end
      else
        flash[:alert] = 'Address can only be updated while order is processing or packing.'
      end
      redirect_to usermodule_order_path(@order)
    end

    def return_item
      order_item = @order.order_items.find(params[:item_id])
      
      if order_item.returnable?
        return_request = ReturnRequest.new(
          order_item: order_item,
          user: current_user,
          reason: params[:reason],
          status: 'pending'
        )

        if return_request.save
          flash[:notice] = 'Return request submitted successfully.'
        else
          flash[:alert] = 'Failed to submit return request.'
        end
      else
        flash[:alert] = 'This item is not eligible for return.'
      end
      
      redirect_to usermodule_order_path(@order)
    end

    private

    def set_order
      @order = current_user.orders.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = 'Order not found.'
      redirect_to usermodule_orders_path
    end

    def address_params
      params.require(:order).permit(:address_id)
    end
  end
end