class Uptest < ActiveRecord::Base
  attr_accessible :filename, :uploadtime, :user_id
  belongs_to :user
  
end
