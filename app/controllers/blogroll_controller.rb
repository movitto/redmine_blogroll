class BlogrollController < ApplicationController
  unloadable

  before_filter :find_project, :authorize

  def index
    last_modified = nil
    @blogs = Blog.find(:all)
    @content = @blogs.collect { |blog| blog.content }.flatten.
                      sort { |s1, s2| s2.date <=> s1.date }
    respond_to do |format|
      format.html
      format.rss  { render :layout => false }
    end
  end

  def blogs
    @blogs = Blog.find(:all)
    @blog  = Blog.new(params[:blog])
  end

  def new_blog
    begin
      success = true
      @blog = Blog.create(params[:blog])
      @blog.save!
    rescue Exception => e
      success = false
      @blogs = Blog.find(:all)
      render :action => :blogs
    end
    redirect_to :action => :blogs,
                :project_id => @project.identifier if success
  end

  def delete_blog
    @blog = Blog.find(params[:id])
    @blog.delete unless @blog.nil?
    redirect_to :action => :blogs, :project_id => @project.identifier
  end

  private
  def find_project
    @project = Project.find(params[:project_id])
  end
end
