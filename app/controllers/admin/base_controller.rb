class Admin::BaseController < ActionController::Base
  layout 'admin/layouts/admin'
  before_action :authenticate_admin_user!
end
