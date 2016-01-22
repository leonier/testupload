class User < ActiveRecord::Base
  attr_accessible :name, :password_hash, :salt
  has_many :uptest
  has_many :notification
  has_many :postthread
  has_many :postreply

	def self.from_omniauth(auth)
#		where(provider: auth.provider, name: auth.uid).first_or_create do |user|
		puts "uid:"+auth.uid.to_s
		puts "name:"+auth.info.name
		puts "email:"+auth.info.email
		where(name: auth.uid).first_or_create do |user|
			#user.provider = auth.provider
			user.name = auth.uid
			user.nickname = auth.info.name
			user.email = auth.info.email
			user.isexternal = true
			user.external_type = auth.provider
			user.oauth_token = auth.credentials.token
			user.oauth_expires_at = Time.at(auth.credentials.expires_at)
			user.save!
		end
	end
end
