class Uptest < ActiveRecord::Base
  attr_accessible :filename, :uploadtime, :user_id
  belongs_to :user

  has_many :attachment
  has_many :postthread, :through => :attachment
  before_destroy { |uptest| Attachment.destroy_all "uptest_id = #{uptest.id}"   }
end
