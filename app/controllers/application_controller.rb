require 'base64'
require 'digest'
require 'securerandom'
class ApplicationController < ActionController::Base
  before_filter :prepare
  protect_from_forgery
  def prepare
	if @appname == nil 
		@appname="FilePoster"
	end
	
	if session[:user_id].blank? ==false
		user=User.find_by_id(session[:user_id])
		if user.blank? == false
			if user.notification.blank? == false
				today=DateTime.now
				@todaynotification=Notification.where(:user_id=>user.id, :date=> today.utc.beginning_of_day..today.utc.end_of_day)	
			end
		end
	end
  end
end
