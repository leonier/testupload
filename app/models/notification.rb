class Notification < ActiveRecord::Base
  attr_accessible :date, :notificationtext, :user_id
  belongs_to :user
end
