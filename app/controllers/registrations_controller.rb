class RegistrationsController < ApplicationController
    def new
        @user = User.new 
    end
    def create
        @user = User.new(registration_params)
        if @user.save
            login @user
            redirect_to usermodule_subcategories_path,alert: 'you must sign in' unless user_signed_in?
        else
            render :new , status: :unprocessable_entity
        end
    end
    private
    def registration_params
        params.require(:user).permit(:email,:password,:password_confirmation)
    end
end
    