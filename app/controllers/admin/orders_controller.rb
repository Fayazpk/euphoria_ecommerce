module Admin
    class OrdersController < ApplicationController
      layout "admin"
  
      before_action :set_order, only: [:show, :update, :cancel, :edit_address, :approve_return, :reject_return, :update_status]
  
      def index
        @orders = Checkout.includes(:user, :address, :return_request)
                          .order(created_at: :desc)
                          .page(params[:page])
                          .per(20)
  
        @orders = filter_orders(@orders)
      end
  
      def show
        @order_items = @order.order_items.includes(:product, :product_variant)
        @status_histories = @order.order_status_histories.includes(:changed_by)
      end
  
      def update
        Rails.logger.debug "Update action called with params: #{params.inspect}"
        Rails.logger.debug "Current order status: #{@order.status}"
        Rails.logger.debug "New status: #{params[:status]}"
  
        if valid_status_transition?(@order.status, params[:status])
          if @order.update_column(:status, params[:status])
            process_status_update
            @order.track_status_change(@order.status, current_admin, params[:notes])
            Rails.logger.debug "Order updated successfully"
            redirect_to admin_orders_path, notice: "Order status updated successfully"
          else
            Rails.logger.debug "Order update failed"
            redirect_to admin_orders_path, alert: "Failed to update order status"
          end
        else
          Rails.logger.debug "Invalid status transition from #{@order.status} to #{params[:status]}"
          redirect_to admin_orders_path, alert: "Invalid status transition"
        end
      end
  
      def update_status
        old_status = @order.status
        
        if @order.send("#{params[:status]}!")
          @order.track_status_change(
            old_status,
            @order.status,
            current_admin,
            params[:notes]
          )
          flash[:notice] = 'Order status updated successfully.'
        else
          flash[:alert] = 'Failed to update order status.'
        end
        
        redirect_to admin_order_path(@order)
      end
  
      def cancel
        if @order.can_cancel?
          @order.update(status: "cancelled", payment_status: "cancelled")
          OrderMailer.cancellation_email(@order.user, @order).deliver_later
          redirect_to admin_orders_path, notice: "Order cancelled successfully"
        else
          redirect_to admin_orders_path, alert: "Order cannot be cancelled"
        end
      end
  
      def edit_address
        if @order.address
          render :edit_address
        else
          redirect_to admin_orders_path, alert: "Address not found for this order"
        end
      end
  
      def update_address
        if @order.address.update(address_params)
          redirect_to admin_orders_path, notice: "Address updated successfully"
        else
          render :edit_address, alert: "Failed to update address"
        end
      end
  
      def approve_return
        @return_request = @order.return_request
  
        if @return_request&.pending?
          ActiveRecord::Base.transaction do
            @return_request.update!(status: 'approved')
  
            wallet = @order.user.wallet
            refund_amount = @order.total_price
  
            if wallet.add_money(refund_amount, "Refund for order ##{@order.id}")
              @return_request.update!(status: 'completed')
              redirect_to admin_orders_path, notice: 'Return request approved and amount refunded'
            else
              raise ActiveRecord::Rollback
              redirect_to admin_orders_path, alert: 'Failed to process refund'
            end
          end
        else
          redirect_to admin_orders_path, alert: 'Invalid return request'
        end
      end
  
      def reject_return
        @return_request = @order.return_request
  
        if @return_request&.pending? && @return_request.update(status: 'rejected')
          redirect_to admin_orders_path, notice: 'Return request rejected'
        else
          redirect_to admin_orders_path, alert: 'Failed to reject return request'
        end
      end
  
      private
  
      def set_order
        @order = Checkout.find(params[:id])
      end
  
      def filter_orders(orders)
        orders = case params[:filter_status]
                 when "pending"
                   orders.where(status: "pending")
                 when "processing"
                   orders.where(status: "processing")
                 when "shipped"
                   orders.where(status: "shipped")
                 when "delivered"
                   orders.where(status: "delivered")
                 when "cancelled"
                   orders.where(status: "cancelled")
                 else
                   orders
                 end
  
        orders = case params[:payment_status]
                 when "pending"
                   orders.where(payment_status: "pending")
                 when "completed"
                   orders.where(payment_status: "completed")
                 when "cancelled"
                   orders.where(payment_status: "cancelled")
                 when "failed"
                   orders.where(payment_status: "failed")
                 else
                   orders
                 end
  
        case params[:return_status]
        when "pending"
          orders.joins(:return_request).where(return_requests: { status: "pending" })
        when "approved"
          orders.joins(:return_request).where(return_requests: { status: "approved" })
        when "rejected"
          orders.joins(:return_request).where(return_requests: { status: "rejected" })
        when "completed"
          orders.joins(:return_request).where(return_requests: { status: "completed" })
        else
          orders
        end
      end
  
      def valid_status_transition?(current_status, new_status)
        transitions = {
          "pending" => ["processing", "cancelled"],
          "processing" => ["shipped", "cancelled"],
          "shipped" => ["delivered", "cancelled"],
          "delivered" => [],
          "cancelled" => []
        }
        transitions[current_status]&.include?(new_status)
      end
  
      def process_status_update
        @order.update_column(:payment_status, "completed") if params[:status] == "delivered" && @order.payment_method == "cod"
      end
  
      def address_params
        params.require(:address).permit(:first_name, :last_name, :building_name, :street_address, :city_name, :state_name, :country_name, :phone)
      end
    end
  end
  