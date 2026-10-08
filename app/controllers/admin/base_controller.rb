class Admin::BaseController < ApplicationController
  layout "admin"
  include AdminAuthentication
end
