class CreateBlogPosts < ActiveRecord::Migration[8.1]
  def change
    create_table :blog_posts do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :excerpt
      t.jsonb :content, null: false, default: '{}'
      t.string :status, null: false, default: "draft"
      t.datetime :published_at

      t.timestamps
    end

    add_index :blog_posts, :slug, unique => true
    add_index :blog_posts, :status
    add_index :blog_posts, :published_at
  end
end
