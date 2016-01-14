require 'digest'
class AdminController < ApplicationController
	before_filter :set_title
	def set_title
		@title="Administration"
	end
	def loginpage
		if session[:admin_id] != nil
			if User.find_by_id(session[:user_id]) != nil
				@error = "Already logon to system!"
				redirect_to :controller=> "admin", :action=> "index"
				return
			end
		end	
	end
	def login
		if session[:admin_id] != nil
			if Admin.find_by_id(session[:admin_id]) != nil
				@error = "Administrator Already logon to system!"
				render "error"
				return
			end
		end
		
		flash[:username]=params[:username]
		
		if checkusername(params[:username], "loginpage") == false
			return
		end
		if checkpassword(params[:password], "loginpage") == false
			return
		end
		testuser=Admin.where(:name => params[:username]).first
		
		hash = genhash(params[:password], "")
		
		if testuser.blank?
			flash[:error]="Wrong Username or Password!" + " Username:" +params[:username]+ " sha2:"+hash
			redirect_to :action=> "loginpage"
			return
		end
		if hash != testuser.sha2
			flash[:error]="Wrong Username or Password!"
			redirect_to :action=> "loginpage"
			return		
		end
		session[:admin_id]=testuser.id
		redirect_to :controller=> "admin", :action=> "index"
	end
	def logout
		session[:admin_id] = nil
		redirect_to :controller=> "admin", :action=> "index"
	end
	def index
		if session[:admin_id] == nil
			redirect_to :controller=> "admin", :action=> "loginpage"
			return
		end		
		if Admin.find_by_id(session[:admin_id]) == nil
			redirect_to :controller=> "admin", :action=> "loginpage"
			return
		end
		@admin=Admin.find_by_id(session[:admin_id])
		@users=User.all
		
	end
	def register
		flash[:username]=params[:username]
		
		if checkusername(params[:username], "registerpage") == false
			return
		end
		if checkpassword(params[:password], "registerpage") == false
			return
		end
		
		salt = SecureRandom.hex
		hash = genhash(params[:password], salt)
		@result= "User:"+params[:username]
		
		newuser=User.new
		newuser.name=params[:username]
		newuser.password_hash=hash
		newuser.salt=salt
		if newuser.save!
			
		else
			flash[:error]="Save error!"
			redirect_to :action=> referer
		end
	end
	def registerpage
	
	end
	def deleteall
		if session[:admin_id] == nil
			redirect_to :controller=> "admin", :action=> "index"
			return
		end		
		if Admin.find_by_id(session[:admin_id]) == nil
			redirect_to :controller=> "admin", :action=> "index"
			return
		end
		if params[:user_id]==nil
			redirect_to :controller=> "admin", :action=> "index"
			return
		end	
		myuser=User.find_by_id(params[:user_id])
		unless myuser == nil?
			unless myuser.uptest.empty?
				myuser.uptest.each do |uptest|
					delfilename=uptest.id.to_s + "_"+ uptest.uploadtime.strftime("%Y%m%d%H%M%S")+File.extname(uptest.filename)
					if File.exist?(Rails.root.join('uploads', delfilename).to_s)
						File.delete(Rails.root.join('uploads', delfilename).to_s)
					end					
					uptest.destroy
				end
			end
		end
		redirect_to :controller=> "admin", :action=> "index"
	end
	def deletenotification
		if session[:admin_id] == nil
			redirect_to :controller=> "admin", :action=> "loginpage"
			return
		end		
		if Admin.find_by_id(session[:admin_id]) == nil
			redirect_to :controller=> "admin", :action=> "loginpage"
			return
		end
		mynotification=Notification.find_by_id(params[:id])
		unless mynotification == nil?
			mynotification.destroy
		end
		redirect_to :controller=> "admin", :action=> "notification"
	end
	def deletenotification_user
		if session[:admin_id] == nil
			redirect_to :controller=> "admin", :action=> "loginpage"
			return
		end		
		if Admin.find_by_id(session[:admin_id]) == nil
			redirect_to :controller=> "admin", :action=> "loginpage"
			return
		end
		myuser=User.find_by_id(params[:userid])
		unless myuser == nil?
			unless myuser.notification.empty?
				myuser.notification.each do |notification|
					notification.destroy
				end
			end
		end
		redirect_to :controller=> "admin", :action=> "notification"
	end
	def notification
		if session[:admin_id] == nil
			redirect_to :controller=> "admin", :action=> "loginpage"
			return
		end		
		if Admin.find_by_id(session[:admin_id]) == nil
			redirect_to :controller=> "admin", :action=> "loginpage"
			return
		end
		@users=User.all
		@notifications=Notification.all
	end
	def newnotification
		@users=User.all
	end
	def newnotification_save
		if session[:admin_id] == nil
			redirect_to :controller=> "admin", :action=> "loginpage"
			return
		end		
		if Admin.find_by_id(session[:admin_id]) == nil
			redirect_to :controller=> "admin", :action=> "loginpage"
			return
		end
		dateerror=0
		myuser=User.find_by_id(params[:userid])
		@info1="User: "+myuser.name
		begin
			startdate = DateTime.strptime(params[:startdate],"%m/%d/%Y")
		rescue
			dateerror = 1
		end
		begin
			enddate = DateTime.strptime(params[:enddate],"%m/%d/%Y")
		rescue
			dateerror = 1
		end
		if dateerror == 0 then
			if enddate <= startdate
				dateerror = 1
			end
		end
		if dateerror == 0 then
			if params[:weekday].blank? == false then
				weekdays=Array.new
				params[:weekday].each do |weekday|
					weekdays.push(weekday.to_i)
				end
				@info2="Date valid!"
				mydate=startdate
				while mydate<=enddate do
					if weekdays.include?(mydate.wday)
						newnotification=Notification.new
						newnotification.user_id=params[:userid]
						newnotification.date=mydate
						newnotification.notificationtext=mydate.strftime("%Y.%m.%d")+" "+params[:notificationtext_base]
						#@info2+=mydate.strftime("%m/%d/%Y")+","
						if newnotification.save!
							@info2="Notification saved!"
						else
							@info2="Notification save error!"
						end
					end
					mydate+=1.day
				end
			else
				@info2="No weekday input!"
			end
		else
			@info2="Date error!"
		end
	end
	def reset_password
		if session[:admin_id] == nil
			redirect_to :controller=> "admin", :action=> "loginpage"
		return
		end		
		if Admin.find_by_id(session[:admin_id]) == nil
			redirect_to :controller=> "admin", :action=> "loginpage"
			return
		end
		
		newuser=User.find_by_id(params[:user_id])
		if newuser == nil
			flash[:error]="Wrong user ID!"
			redirect_to :controller=> "admin", :action=> "index"	
			return
		end		
		
		if checkpassword(params[:newpassword], "index") == false
			return
		end
		
		salt = SecureRandom.hex
		hash = genhash_user(params[:newpassword], salt)
		
		newuser.password_hash=hash
		newuser.salt=salt
		newuser.save!
		flash[:error]="Successfully updated password for user "+newuser.name
		redirect_to :controller=> "admin", :action=> "index"
	end
private
	def checkusername(username, referer)
		if username.empty?
			flash[:error]="Please input your User name!"
			redirect_to :action=> referer
			return false
		end
		if username.length<5 or username.length>25
			flash[:error]="User name length too long or too short!"
			redirect_to :action=> referer
			return false
		end
		if all_letters_or_digits(username) == false
			flash[:error]="User name should only contain letters or digits or -/_!"
			redirect_to :action=> referer
			return false
		end
	end
	def checkpassword(password, referer)
		if password.empty?
			flash[:error]="Please input your Password!"
			redirect_to :action=> referer
			return false
		end
		if password.length<5 or password.length>25
			flash[:error]="Password length too long or too short!"
			redirect_to :action=> referer
			return false
		end	
	end
	def genhash(password, salt)
		mypassword=password+salt
		myhash=Digest::SHA2.hexdigest(mypassword)
		return myhash
	end
	def genhash_user(password, salt)
		mypassword=password+salt
		myhash=Digest::SHA1.hexdigest(mypassword)
		return myhash
	end
	def all_letters_or_digits(str)
		str[/[a-zA-Z0-9-_]+/]  == str
	end
end
