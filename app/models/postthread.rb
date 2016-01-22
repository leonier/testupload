class Postthread < ActiveRecord::Base
  attr_accessible :content, :title, :user_id
  belongs_to :user
  has_many :postreply

  has_many :attachment
  has_many :uptest, :through => :attachment
  before_destroy { |postthread| Attachment.destroy_all "postthread_id = #{postthread.id}"   }
end
