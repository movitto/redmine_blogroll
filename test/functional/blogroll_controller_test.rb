require File.dirname(__FILE__) + '/../test_helper'

class BlogrollControllerTest < ActionController::TestCase
  fixtures :projects, :versions, :users, :roles, :members, :member_roles, :issues, :journals, :journal_details,
           :trackers, :projects_trackers, :issue_statuses, :enabled_modules, :enumerations, :boards, :messages,
           :attachments, :custom_fields, :custom_values, :time_entries,
           :blogs, :blog_entries

  def setup
    @project = Project.find(1)
    @project.enabled_module_names = [:blogroll]
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @request.session[:user_id] = 2
    Role.find(1).add_permission! :view_blogroll
    Role.find(1).add_permission! :manage_blogroll
    User.current = User.find(2)
  end

  def test_routing
    assert_routing({:method => :get, :path => '/blogroll'},
                    :controller => 'blogroll', :action => 'index')
    assert_routing({:method => :get, :path => '/blogroll/blogs'},
                    :controller => 'blogroll', :action => 'blogs')
    assert_routing({:method => :get, :path => '/blogroll/new_blog'},
                    :controller => 'blogroll', :action => 'new_blog')
    assert_routing({:method => :get, :path => '/blogroll/delete_blog'},
                    :controller => 'blogroll', :action => 'delete_blog')
  end

  def test_permissions
    # TODO
    #   - permission denied  for index, blogs, new_blog, delete_blog
    #   - permission granted for index, blogs, new_blog, delete_blog
  end

  def test_index
    get :index, :project_id => @project.identifier
    assert_response :success
    assert_not_nil assigns(:blogs)
    assert_not_nil assigns(:content)
    assert_template("index.html.erb")
  end

  def test_feed
    get :index, {:format => 'rss', :project_id => @project.identifier}
    assert_response :success
    assert_not_nil assigns(:blogs)
    assert_not_nil assigns(:content)
    assert_template("index.rss.builder")
  end

  def test_blogs
    get :blogs, :project_id => @project.identifier
    assert_response :success
    assert_template("blogs.html.erb")
    assert_not_nil assigns(:blogs)
    assert_not_nil assigns(:blog)
  end

  def test_new_blog
    b = Blog.count
    post :new_blog, {'blog' => {'url' => 'http://google.com', 'author' => 'test_new_blog'},
                     :project_id => @project.identifier }

    assert  Blog.count == (b+1)
    assert Blog.find(:all, :conditions => ['url = ? AND author = ?', 'http://google.com',
                                                                      'test_new_blog']).size == 1
    assert_response :redirect
    assert_redirected_to "/blogroll/blogs?project_id=#{@project.identifier}"
  end

  def test_failed_new_blog
    b = Blog.count
    post :new_blog, {'blog' => {'url' => 'test_invalid_uri', 'author' => 'test_failed_new_blog'},
                     :project_id => @project.identifier }
    assert Blog.count == b
    assert Blog.find(:all, :conditions => ['url = ?',  'test_new_blog']).size == 0
                                                                                    
    assert_response :success
  end

  def test_delete_blog
    post :new_blog, {'blog' => {'url' => 'http://amazon.com', 'author' => 'test_delete_blog'},
                     :project_id => @project.identifier }
    b = Blog.count
    blog = Blog.find(:first, :conditions => ['url = ?', 'http://amazon.com'])

    post :delete_blog, {:id => blog.id,
                        :project_id => @project.identifier }
    assert_response :redirect # we do succeed here as we simply redirect to the blogs page to display err
    assert_redirected_to "/blogroll/blogs?project_id=#{@project.identifier}"

    assert Blog.count == (b-1)
    assert Blog.find(:all, :conditions => ['url = ?',  'test_delete_blog']).size == 0
  end
end
