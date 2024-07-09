class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :fetch_home_data

  protected
  def fetch_home_data
    @categories = Category.grouped_data
  end
end
