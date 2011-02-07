class AdminController < ApplicationController
  layout 'admin'
  
  before_filter :require_user #ensure we are logged in
  before_filter :require_admin #ensure we are an admin

end