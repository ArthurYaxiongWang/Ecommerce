class Dashboard::BaseController < ApplicationController
  before_action :authenticate_user
  before_action :fetch_home_data
  
end
