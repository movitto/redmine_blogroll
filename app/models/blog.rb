require 'cgi'

require 'simple-rss'
require 'open-uri'

class Blog < ActiveRecord::Base
 unloadable

 has_many :blog_entries

 validates_format_of :url, :with => URI::regexp(%w(http https))  

 validates_presence_of   [:author, :url]

 validates_uniqueness_of :url

 # retrieve the blog's content
 def content
   rss = nil
   begin
     rss = SimpleRSS.parse open(url)
   # if we can't open it, just silently ignore it
   rescue OpenURI::HTTPError, SimpleRSSError => e
     return []
   end

   # return if feed not updated since we last checked 
   last_modified = rss.channel.pubDate || rss.channel.lastBuildDate || rss.channel.modified || Time.now.gmtime
   return blog_entries if !last_updated.nil? && last_modified <= last_updated

   self.last_updated = Time.now

   self.blog_entries.clear

   rss.items.each { |item|
     self.blog_entries << 
      BlogEntry.new({ :title => item.title,
         :link => item.link,
         :date => item.pubDate || item.lastBuildDate || item.modified || Time.now.gmtime,
         :content => CGI.unescapeHTML(item.description)}) # NOTE unescaping html here, potentially dangerous!!!
   }

   save!
   return blog_entries
 end
end
