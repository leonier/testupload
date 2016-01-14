require 'base64'
class UptestController < ApplicationController
	def index
		if session[:user_id] == nil
			render "notlogin"
			return
		end
		@user=User.find_by_id(session[:user_id])
		if @user.blank?
			render "notlogin"
			return
		end	
		if @user.notification.blank? == false
			today=DateTime.now
			@today_notification=Notification.where(:user_id=>@user.id, :date=> today.utc.beginning_of_day..today.utc.end_of_day)	
		end
		@files=Uptest.where(:user_id => session[:user_id])
	end
	def upload
		if session[:user_id] == nil
			@error="Not logged in"
			render "error"
			return
		end
		user=User.find_by_id(session[:user_id])
		if user.blank?
			@error="Not logged in"
			render "error"
			return
		end
		if params[:upload] == nil

		else 
  			data=params[:upload]
			uptime=DateTime.now
			newuptest=Uptest.new(:filename=>data[:datafile].original_filename,:uploadtime =>uptime)
			newuptest.user_id=session[:user_id]
			newuptest.save!
			newfilename=newuptest.id.to_s + "_"+ newuptest.uploadtime.strftime("%Y%m%d%H%M%S")+File.extname(data[:datafile].original_filename)
			File.open(Rails.root.join('uploads', newfilename), 'wb') do |of|
    				of.write(data[:datafile].read)
 		end
		end
  		redirect_to :action => "index"
	end
	def download
		islogin = 1
		if session[:user_id] == nil
			islogin = 0
		end
		if islogin == 1
			user=User.find_by_id(session[:user_id])
			if user.blank?
				islogin = 0
			end
		end
		downfile=Uptest.find_by_id(params[:file_id])
	
		if downfile == nil
			redirect_to :action => "downerr"
		else
			ispublic=downfile.public
			if ispublic != 1 and islogin == 0 
				redirect_to :action => "downerr"
				return
			end
			downfilename=downfile.id.to_s + "_"+ downfile.uploadtime.strftime("%Y%m%d%H%M%S")+File.extname(downfile.filename)
			send_file(Rails.root.join('uploads', downfilename).to_s, :filename=>downfile.filename)
		end
	end
	def delete
		deletefile=Uptest.find_by_id(params[:file_id])
		if deletefile == nil
		else
			delfilename=deletefile.id.to_s + "_"+ deletefile.uploadtime.strftime("%Y%m%d%H%M%S")+File.extname(deletefile.filename)
			if File.exist?(Rails.root.join('uploads', delfilename).to_s)
				File.delete(Rails.root.join('uploads', delfilename).to_s)
				deletefile.destroy
			end
		end
		redirect_to :action => "index"
	end
	def rename
		@renameid=params[:id]
		@newname= params[:newname]
		renamefile=Uptest.find_by_id(params[:id])
		renamefile.filename=@newname
		if renamefile.save
			render :text=> "Rename Success!"
		else
			render :text=> "Rename Fail!"
		end
		return
	end
	def upinfo
		publiclink = 0
		@public = 0
		@fileid = 0
		
		if params[:id] == nil
			if params[:b64] != nil
			begin  
				b64org=params[:b64] + '=' * (-1 * params[:b64].size & 3)
				txt=Base64.urlsafe_decode64(b64org)
				fileid,trail=txt.split('@',2)
				publiclink = 1
			rescue
				@error= "Wrong link!"
				render "error"
				return
			end
			else
				@error= "no File ID!"
				render "error"
				return
			end
		else
			if session[:user_id] == nil
				@error="Not logged in"
				render "error"
				return
			end
			user=User.find_by_id(session[:user_id])
			if user.blank?
				@error="Not logged in"
				render "error"
				return
			end
			fileid=params[:id]
		end
		
		myfile=Uptest.find_by_id(fileid)
		if publiclink == 1 and myfile.public == 1
			@public = 1
			@fileid=fileid
		end
		@filename=myfile.filename
		@uptime=myfile.uploadtime.strftime("%Y.%m.%d %H:%M:%S")
		downfilename=myfile.id.to_s + "_"+ myfile.uploadtime.strftime("%Y%m%d%H%M%S")+File.extname(myfile.filename)
		fullpath=Rails.root.join('uploads', downfilename)
		@size=File.size(fullpath)
	end
	def editall
		if session[:user_id] == nil
			render "notlogin"
			return
		end
		@user=User.find_by_id(session[:user_id])
		if @user.blank?
			render "notlogin"
			return
		end	
		@files=Uptest.where(:user_id => session[:user_id])
	end
	def saveall
		@updatecnt=0
		@uptests=params[:uptest]
		@uptests.each do |uptest| 
			ischanged = 0
			ispublic = 0
			if uptest["public"] == "public"
				ispublic = 1
			end
			
			myfile=Uptest.find_by_id(uptest["id"])
			if myfile.filename != uptest["filename"]
				myfile.filename=uptest["filename"]
				ischanged = 1
			end
			
			if myfile.public != ispublic 
				unless ispublic == 0 and myfile.public == nil
					myfile.public=ispublic
					ischanged = 1
				end
			end
			
			if ischanged != 0
				if myfile.save 
					@updatecnt = @updatecnt+1
				end
			end
			
		end
		#redirect_to :action => "index"
	end
	def set_public
		if session[:user_id] == nil
			render "notlogin"
			return
		end
		@user=User.find_by_id(session[:user_id])
		if @user.blank?
			render "notlogin"
			return
		end	
		
		myfile=Uptest.find_by_id(params[:id])
		if myfile == nil
			@error="No such file ID!"
			render "error"
			return
		end
		if myfile.public == 0
			myfile.public = 1
		else
			myfile.public = 0
		end
		myfile.save!
		redirect_to :action => "index"
	end
end
