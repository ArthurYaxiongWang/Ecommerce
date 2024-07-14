class AddressesController < ApplicationController
  before_action :authenticate_user

  def index
    @addresses = current_user.addresses.order("id desc")
  end

  def set_default_address
    
  end
end
