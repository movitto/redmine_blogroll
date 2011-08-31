require 'redmine'

Redmine::Plugin.register :redmine_blogroll do
  name 'Redmine Blogroll plugin'
  author 'Mo Morsi'
  description 'Provides rss feed aggregator functionality to Redmine'
  version '0.3.8'
  url 'http://github.com/movitto/redmine_blogroll'
  author_url 'http://mo.morsi.org'

  project_module :blogroll do
    permission :view_blogroll,   :blogroll => :index
    permission :manage_blogroll, :blogroll => [:blogs, :new_blog, :delete_blog]
  end
  menu :project_menu, :blogroll, { :controller => 'blogroll', :action => 'index' }, :caption => 'Blogroll', :after => :activity, :param => :project_id
end
