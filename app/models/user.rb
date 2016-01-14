class User < ActiveRecord::Base
  attr_accessible :name, :password_hash, :salt
  has_many :uptest
  has_many :notification
  has_many :postthread
  has_many :postreply

end
