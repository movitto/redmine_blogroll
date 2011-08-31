class CreateBlogs < ActiveRecord::Migration
  def self.up
    create_table :blogs do |t|
      t.column :url, :string
      t.column :author, :string
      t.column :last_updated, :datetime
    end
  end

  def self.down
    drop_table :blogs
  end
end
