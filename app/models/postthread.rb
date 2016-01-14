class Postthread < ActiveRecord::Base
  attr_accessible :content, :title, :user_id
  belongs_to :user
  has_many :postreply
end
