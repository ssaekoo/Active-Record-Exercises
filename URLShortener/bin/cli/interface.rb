require 'launchy'

puts "input your email"
email = gets.chomp
puts """ What do you want to do?
  0. Create shortened URL
  1. Visit shortened URL
  """
input = gets.chomp
if input == 0
  puts "Type in your long url"
  long_url = gets.chomp
  a = ShortenedUrl.create_for_user_and_long_url!((Users.find_by email: email), long_url)
  puts a.short_url
else
  Launchy.open('Google.com')
end
