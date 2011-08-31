require File.dirname(__FILE__) + '/../test_helper'

class BlogTest < ActiveSupport::TestCase
  fixtures :blogs

  def test_validations
    b = Blog.new({ :url => 'http://ebay.com', :author => 'EBay' })
    assert b.valid?

    b.url = nil
    assert !b.valid?
    b.url = 'http://ebay.com'
    # assert b.errors.contains...

    b.url = 'some-invalid-format'
    assert !b.valid?
    b.url = 'http://ebay.com'

    b.author = nil
    assert !b.valid?
    b.author = 'EBay'

    b.save!

    c = Blog.new({ :url => 'http://ebay.com', :author => 'Another' })
    assert !c.valid?
  end

  def test_content
    # TODO the tricky one ;-)
    # Create mock rss feed (perhaps just a file on-disk?) and validate:
    #   - verifies valid rss feed
    #   - returns existing entries if not updated
    #   - if updated:
    #      - sets timestamp
    #      - clears existing blog entries
    #      - creates new blog entries w/ appropriate content
  end

end
