# Create Posts
50.times do
  Advertisement.create!(
    title: RandomData.random_sentence,
    copy: RandomData.random_paragraph,
    price: rand(1..99)
  )
end

puts "Seed finished"
puts "#{Advertisement.count} ads created"
