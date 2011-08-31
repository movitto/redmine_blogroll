require File.dirname(__FILE__) + '/../test_helper'

class BlogEntryTest < ActiveSupport::TestCase
  fixtures :blog_entries

  def test_validations
    b = Blog.create({ :url => 'http://slashdot.org', :author => 'slashdot' })
    be = BlogEntry.new({:blog_id => b.id,
                       :title => 'example post',
                       :link => 'http://slashdot.org',
                       :content => 'foobar'})

    assert be.valid?

    be.blog_id = nil
    assert !be.valid?
    be.blog_id = b.id

    be.title = nil
    assert !be.valid?
    be.title = 'example post'

    be.link = nil
    assert !be.valid?
    be.link = 'http://slashdot.org'

    be.content = nil
    assert !be.valid?
    be.content = 'foobar'
  end
end
