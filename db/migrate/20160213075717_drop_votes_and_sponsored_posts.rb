class DropVotesAndSponsoredPosts < ActiveRecord::Migration
  def change
    drop_table :votes
    drop_table :sponsored_posts
  end
end
