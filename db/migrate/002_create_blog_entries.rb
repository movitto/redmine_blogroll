class CreateBlogEntries < ActiveRecord::Migration
  def self.up
    create_table :blog_entries do |t|
      t.column :blog_id, :integer
      t.column :title, :string
      t.column :link, :string
      t.column :date, :datetime
      t.column :content, :string
    end
  end

  def self.down
    drop_table :blog_entries
  end
end
