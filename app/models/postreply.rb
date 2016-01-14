class Postreply < ActiveRecord::Base
  attr_accessible :content, :postthread_id, :title, :user_id
  belongs_to :user
  belongs_to :postthread 
end
