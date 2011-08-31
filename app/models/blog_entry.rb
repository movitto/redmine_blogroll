class BlogEntry < ActiveRecord::Base
  unloadable

  belongs_to :blog
  validates_presence_of [:blog_id, :title, :link, :content]
end
