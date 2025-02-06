module Usermodule
  class WalletsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_wallet

    def show
      @wallet_transactions = @wallet.wallet_transactions
    end

    def add_money
      amount = params[:amount].to_f
      if @wallet.add_money(amount, "Money added by user")
        redirect_to usermodule_wallet_path, notice: 'Money added to your wallet successfully.'
      else
        redirect_to usermodule_wallet_path, alert: @wallet.errors.full_messages.join(', ')
      end
    end

    def deduct_money
      amount = params[:amount].to_f
      if @wallet.deduct_money(amount, nil, "Purchase payment")
        redirect_to usermodule_wallet_path, notice: 'Money deducted from your wallet successfully.'
      else
        redirect_to usermodule_wallet_path, alert: @wallet.errors.full_messages.join(', ')
      end
    end

    private

    def set_wallet
      @wallet = current_user.wallet || current_user.create_wallet
    end
  end
end
