# Create Posts
50.times do
  Post.create!(
    title: RandomData.random_sentence,
    body: RandomData.random_paragraph
  )
end
posts = Post.all

# Create Comments
100.times do
  Comment.create!(
    post: posts.sample,
    body: RandomData.random_paragraph
  )
end

Post.find_or_create_by(title: "My super-unique post", body: "This is a post that totes doesn't already exist.")
Comment.find_or_create_by(post: Post.find_or_create_by(title: "My super-unique post", body: "This is a post that totes doesn't already exist."), body: "This is a totally unique comment too.")

puts "Seed finished"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"
