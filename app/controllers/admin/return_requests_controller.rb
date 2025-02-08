module Admin
    class ReturnRequestsController < ApplicationController
      before_action :authenticate_admin!
      before_action :set_return_request, only: [:show, :process_return]
  
      def index
        @q = ReturnRequest.ransack(params[:q])
        @return_requests = @q.result
                            .includes(:order_item, :user)
                            .order(created_at: :desc)
                            .page(params[:page])
      end
  
      def show
      end
  
      def process_return
        if @return_request.send("#{params[:status]}!")
          flash[:notice] = 'Return request processed successfully.'
        else
          flash[:alert] = 'Failed to process return request.'
        end
        
        redirect_to admin_return_request_path(@return_request)
      end
  
      private
  
      def set_return_request
        @return_request = ReturnRequest.find(params[:id])
      end
    end
  end