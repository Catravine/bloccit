class AddCommentableToComments < ActiveRecord::Migration
  def change
    rename_column :comments, :post_id, :commentable_id
    add_column :comments, :commentable_type, :string
    add_index :comments, :commentable_type
    execute("update comments set commentable_type = 'Post';")
  end
end
