class RemoveCommentableFromComments < ActiveRecord::Migration
  def change
    remove_column :comments, :commentable_type
    rename_column :comments, :commentable_id, :post_id
  end
end
