class Attachment < ActiveRecord::Base
  belongs_to :uptest
  belongs_to :postthread
  # attr_accessible :title, :body
  validates :uptest_id, uniqueness:  { scope: :postthread_id }
end
