module Usermodule
  class AddressesController < ApplicationController
    before_action :set_usermodule_address, only: %i[show edit update destroy]

    # GET /usermodule/addresses or /usermodule/addresses.json
    def index
      @usermodule_addresses = current_user.addresses
    end

    # GET /usermodule/addresses/1 or /usermodule/addresses/1.json
    def show
    end

    # GET /usermodule/addresses/new
    def new
      @usermodule_address = current_user.addresses.new
    end

    # GET /usermodule/addresses/1/edit
    def edit
    end

    # POST /usermodule/addresses or /usermodule/addresses.json
    def create
      @usermodule_address = current_user.addresses.new(usermodule_address_params)

      respond_to do |format|
        if @usermodule_address.save
          format.html { redirect_to usermodule_address_path(@usermodule_address), notice: "Address was successfully created." }
          format.json { render :show, status: :created, location: @usermodule_address }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @usermodule_address.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /usermodule/addresses/1 or /usermodule/addresses/1.json
    def update
      respond_to do |format|
        if @usermodule_address.update(usermodule_address_params)
          format.html { redirect_to usermodule_address_path(@usermodule_address), notice: "Address was successfully updated." }
          format.json { render :show, status: :ok, location: @usermodule_address }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @usermodule_address.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /usermodule/addresses/1 or /usermodule/addresses/1.json
    def destroy
      @usermodule_address.destroy
      respond_to do |format|
        format.html { redirect_to usermodule_addresses_url, notice: "Address was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_usermodule_address
      @usermodule_address = current_user.addresses.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def usermodule_address_params
      params.require(:address).permit(:first_name, :last_name, :building_name, :street_address, :phone, :country_name, :state_name, :city_name)
    end
  end
end
