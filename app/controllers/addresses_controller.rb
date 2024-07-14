# app/controllers/addresses_controller.rb
class AddressesController < ApplicationController
  before_action :authenticate_user
  before_action :find_address, only: [:edit, :update, :destroy, :set_default_address]
  before_action :load_provinces, only: [:new, :edit]

  def index
    @addresses = current_user.addresses
  end

  def new
    @address = current_user.addresses.new
  end

  def create
    @address = current_user.addresses.new(address_params)
    if @address.save
      @addresses = current_user.reload.addresses
      redirect_to addresses_path, notice: 'Address was successfully created.'
    else
      render :new
    end
  end

  def edit
    @address = current_user.addresses.find(params[:id])
    render :new
  end

  def update
    @address = current_user.addresses.find(params[:id])
    if @address.update(address_params)
      @addresses = current_user.reload.addresses
      redirect_to addresses_path, notice: 'Address was successfully updated.'
    else
      render :new
    end
  end

  def destroy
    @address = current_user.addresses.find(params[:id])
    @address.destroy

    @addresses = current_user.addresses
    redirect_to addresses_path, notice: 'Address was successfully deleted.'
  end

  def set_default_address
    @address = current_user.addresses.find(params[:id])
    current_user.update(default_address: @address)
    redirect_to addresses_path, notice: 'Default address set successfully.'
  end

  private

  def address_params
    params.require(:address).permit(:contact_name, :cellphone, :address, :zip_code, :province_id, :set_as_default)
  end

  def find_address
    @address = current_user.addresses.find(params[:id])
  end

  def load_provinces
    @provinces = Province.all
  end
end
