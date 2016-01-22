class PostthreadController < ApplicationController
	before_filter :set_title
	def set_title
		@title="Forum"
	end
	def index
		if session[:user_id] != nil
			@user=User.find_by_id(session[:user_id])
		else
			@user=nil
		end
		@postthreads=Postthread.all
	end
	def new_thread_save
		haveattachment = 0
		if session[:user_id] == nil
			@error="Not logged in!"
			render "error"
			return
		end
		@user=User.find_by_id(session[:user_id])
		if @user.blank?
			@error="Not logged in!"
			render "error"
			return
		end
		flash[:title]=params[:title]
		flash[:content]=params[:content]
		if params[:user_id].blank? or @user.id != params[:user_id].to_i
			flash[:error]="Incorrect user ID!"
			redirect_to :back
			return			
		end
		if params[:title].blank?
			flash[:error]="You must enter title!"
			redirect_to :back
			return
		end
		if params[:content].blank?
			flash[:error]="You must enter content!"
			redirect_to :back
			return
		end
		if params[:title].size<5 or params[:title].size>256
			flash[:error]="Wrong title length!"
			redirect_to :back
			return
		end		
		if params[:content].size<8 or params[:content].size>65535
			flash[:error]="Wrong content length!"
			redirect_to :back
			return
		end		
		if params[:attachment_select].blank? == false and params[:attachment_select] != '-2' and params[:attachment_select] !='-1'
			myuptest=Uptest.find_by_id(params[:attachment_select])
			if myuptest.blank?
				flash[:error]="Wrong Attachment ID!"
				redirect_to :back
				return			
			end
			haveattachment = 1
		end
		newthread=Postthread.new
		newthread.user_id=params[:user_id]
		newthread.title=params[:title]
		newthread.content=params[:content]
		newthread.save!
		#Upload new attachment.
		if params[:attachment_select] == '-2' and params[:upload] != nil
			data=params[:upload]
			uptime=DateTime.now
			myuptest=Uptest.new(:filename=>data[:datafile].original_filename,:uploadtime =>uptime)
			myuptest.user_id=@user.id
			myuptest.public = 1
			myuptest.save!
			newfilename=myuptest.id.to_s + "_"+ myuptest.uploadtime.strftime("%Y%m%d%H%M%S")+File.extname(data[:datafile].original_filename)
			File.open(Rails.root.join('uploads', newfilename), 'wb') do |of|
    				of.write(data[:datafile].read)	
			end
			haveattachment = 1	
		end
		#Attachment process.
		if haveattachment == 1
			newattach=Attachment.new
			newattach.postthread_id=newthread.id
			newattach.uptest_id=myuptest.id
			newattach.save!
			myuptest.public = 1
			myuptest.save!
		end
			
		flash.discard
		redirect_to :back
	end
	def view
		@user=User.find_by_id(session[:user_id])
		@postthread=Postthread.find_by_id(params[:id])
		if @postthread == nil
			@error="Thread not found!"
			render "error"
			return
		end
		@title+=": "+@postthread.title
		@poster=@postthread.user
		@attachments=@postthread.attachment
		@replies=@postthread.postreply
	end
	def reply_save
		if session[:user_id] == nil
			@error="Not logged in!"
			render "error"
			return
		end
		@user=User.find_by_id(session[:user_id])
		if @user.blank?
			@error="Not logged in!"
			render "error"
			return
		end	
		flash[:nrtitle]=params[:title]
		flash[:nrcontent]=params[:content]
		if params[:user_id].blank? or @user.id != params[:user_id].to_i
			flash[:error]="Incorrect user ID!"
			redirect_to :back
			return			
		end
		if params[:user_id].blank? or @user.id != params[:user_id].to_i
			flash[:error]="Incorrect user ID!"
			redirect_to :back
			return			
		end		
		@postthread=Postthread.find_by_id(params[:postthread_id])
		if @postthread.blank?
			flash[:error]="Incorrect thread ID!"
			redirect_to :back
			return
		end	
		if params[:title].blank?
			flash[:error]="You must enter title!"
			redirect_to :back
			return
		end
		if params[:content].blank?
			flash[:error]="You must enter content!"
			redirect_to :back
			return
		end
		if params[:title].size<5 or params[:title].size>256
			flash[:error]="Wrong title length!"
			redirect_to :back
			return
		end		
		if params[:content].size<8 or params[:content].size>65535
			flash[:error]="Wrong content length!"
			redirect_to :back
			return
		end		
		newreply=Postreply.new
		newreply.user_id=@user.id
		newreply.postthread_id=@postthread.id
		newreply.title=params[:title]
		newreply.content=params[:content]
		newreply.save!
		flash.discard
		redirect_to :back
	end
	def edit
		if session[:user_id] == nil
			@error="Not logged in!"
			render "error"
			return
		end
		@user=User.find_by_id(session[:user_id])
		if @user.blank?
			@error="Not logged in!"
			render "error"
			return
		end	
		@postthread=Postthread.find_by_id(params[:id])
		if @postthread.blank?
			@error="Incorrect thread ID!"
			render "error"
			return
		end		
		@allattachment=@postthread.attachment
		@alluptest=@user.uptest
		@allattachment.each do |attachment|
			@alluptest.delete_if{|uptest|uptest.id==attachment.uptest_id}
		end
	end
	def edit_save
		havenewattachment = 0
		if session[:user_id] == nil
			@error="Not logged in!"
			render "error"
			return
		end
		@user=User.find_by_id(session[:user_id])
		if @user.blank?
			@error="Not logged in!"
			render "error"
			return
		end	
		flash[:ttitle]=params[:title]
		flash[:tcontent]=params[:content]
		if params[:user_id].blank? or @user.id != params[:user_id].to_i
			flash[:error]="Incorrect user ID!"
			redirect_to :back
			return			
		end

		@postthread=Postthread.find_by_id(params[:postthread_id])
		if @postthread.blank?
			flash[:error]="Incorrect thread ID!"
			redirect_to :back
			return
		end	
		if params[:title].blank?
			flash[:error]="You must enter title!"
			redirect_to :back
			return
		end
		if params[:content].blank?
			flash[:error]="You must enter content!"
			redirect_to :back
			return
		end
		if params[:title].size<5 or params[:title].size>256
			flash[:error]="Wrong title length!"
			redirect_to :back
			return
		end		
		if params[:content].size<8 or params[:content].size>65535
			flash[:error]="Wrong content length!"
			redirect_to :back
			return
		end		

		if params[:attachment_select].blank? == false and params[:attachment_select] != '-2' and params[:attachment_select] !='-1'
			myuptest=Uptest.find_by_id(params[:attachment_select])
			if myuptest.blank?
				flash[:error]="Wrong Attachment ID!"
				redirect_to :back
				return			
			end
			havenewattachment = 1
		end	
		@postthread.title=params[:title]
		@postthread.content=params[:content]
		@postthread.save!
		#Upload new attachment.
		if params[:attachment_select] == '-2' and params[:upload] != nil
			data=params[:upload]
			uptime=DateTime.now
			myuptest=Uptest.new(:filename=>data[:datafile].original_filename,:uploadtime =>uptime)
			myuptest.user_id=@user.id
			myuptest.public = 1
			myuptest.save!
			newfilename=myuptest.id.to_s + "_"+ myuptest.uploadtime.strftime("%Y%m%d%H%M%S")+File.extname(data[:datafile].original_filename)
			File.open(Rails.root.join('uploads', newfilename), 'wb') do |of|
    				of.write(data[:datafile].read)	
			end
			havenewattachment = 1	
		end

		#Attachment process.
		if havenewattachment == 1
			newattach=Attachment.new
			newattach.postthread_id=@postthread.id
			newattach.uptest_id=myuptest.id
			newattach.save!
			myuptest.public = 1
			myuptest.save!
		end		

		flash.discard
	end
	def edit_reply
		if session[:user_id] == nil
			@error="Not logged in!"
			render "error"
			return
		end
		@user=User.find_by_id(session[:user_id])
		if @user.blank?
			@error="Not logged in!"
			render "error"
			return
		end	
		@postreply=Postreply.find_by_id(params[:id])
		if @postreply.blank?
			@error="Incorrect reply ID!"
			render "error"
			return
		end			
	end
	def edit_reply_save
		if session[:user_id] == nil
			@error="Not logged in!"
			render "error"
			return
		end
		@user=User.find_by_id(session[:user_id])
		if @user.blank?
			@error="Not logged in!"
			render "error"
			return
		end	
		flash[:rtitle]=params[:title]
		#flash[:rcontent]=params[:content]
		if params[:user_id].blank? or @user.id != params[:user_id].to_i
			flash[:error]="Incorrect user ID!"
			redirect_to :back
			return			
		end
		if params[:user_id].blank? or @user.id != params[:user_id].to_i
			flash[:error]="Incorrect user ID!"
			redirect_to :back
			return			
		end		
		@postreply=Postreply.find_by_id(params[:postreply_id])
		if @postreply.blank?
			flash[:error]="Incorrect reply ID!"
			redirect_to :back
			return
		end	
		if params[:title].blank?
			flash[:error]="You must enter title!"
			redirect_to :back
			return
		end
		if params[:content].blank?
			flash[:error]="You must enter content!"
			redirect_to :back
			return
		end
		if params[:title].size<5 or params[:title].size>256
			flash[:error]="Wrong title length!"
			redirect_to :back
			return
		end		
		if params[:content].size<8 or params[:content].size>65535
			flash[:error]="Wrong content length!"
			redirect_to :back
			return
		end		
		@postreply.title=params[:title]
		@postreply.content=params[:content]
		@postreply.save!
		flash.discard	
	end
	def delete
		if session[:user_id] == nil
			@error="Not logged in!"
			render "error"
			return
		end
		@user=User.find_by_id(session[:user_id])
		if @user.blank?
			@error="Not logged in!"
			render "error"
			return
		end	
		postthread=Postthread.find_by_id(params[:postthread_id])
		if postthread.blank?
			flash[:error]="Incorrect thread ID!"
			redirect_to :back
			return
		end
		if postthread.user_id != @user.id
			flash[:error]="Incorrect thread ID!"
			redirect_to :back
			return
		end		
		if postthread.postreply != nil
			postthread.postreply.each do |postreply|
				postreply.destroy
			end
		end
		postthread.destroy
	end
	def delete_reply
		if session[:user_id] == nil
			@error="Not logged in!"
			render "error"
			return
		end
		@user=User.find_by_id(session[:user_id])
		if @user.blank?
			@error="Not logged in!"
			render "error"
			return
		end	
		postreply=Postreply.find_by_id(params[:postreply_id])
		if postreply.blank?
			flash[:error]="Incorrect reply ID!"
			redirect_to :back
			return
		end
		if postreply.user_id != @user.id
			flash[:error]="Incorrect reply ID!"
			redirect_to :back
			return
		end		
		@postthread=postreply.postthread
		postreply.destroy
	end
end