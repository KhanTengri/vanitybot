require 'rubygems'
require 'twitter'
require 'tweetstream'
require 'json'
require 'pp'


Twitter.configure do |config|
  config.consumer_key = 'key'
  config.consumer_secret = 'secret'
  config.oauth_token = 'access token'
  config.oauth_token_secret = 'token secret'
end

TweetStream.configure do |config|
  config.consumer_key = 'key'
  config.consumer_secret = 'secret'
  config.oauth_token = 'access token'
  config.oauth_token_secret = 'token secret'
  config.auth_method = :oauth
end


client = TweetStream::Client.new
client.on_event(:anything) do |data|
t = Time.now
tt = t.strftime "%Y-%m-%d %H:%M:%S"
timestamp= t.strftime "%Y-%m-%d"
filename = "./logs/" + timestamp + ".csv"

if data[:retweeted_status] != nil
File.open(filename,'a') do |f1|
   storage = tt + ","+ 'retweet' + ",#{data[:user][:screen_name]},#{data[:user][:followers_count]},#{data[:user][:verified]},#{data[:retweeted_status][:id]},#{data[:retweeted_status][:created_at]}"
   f1.puts storage
   pp storage
   end
   
if data[:user][:verified] == true
   retweetmessage = "@"+"#{data[:user][:screen_name]}"+" just retweeted ePuppy!"
  Twitter.direct_message_create('your user id here', retweetmessage )
  end
end

if data[:event] == 'follow'
message = "@"+"#{data[:source][:screen_name]}"+" just "+ "#{data[:event]}" +"ed you!"
File.open(filename,'a') do |f1|
storage = tt + ",#{data[:event]},#{data[:source][:screen_name]},#{data[:source][:followers_count]},#{data[:source][:verified]},,"
   f1.puts storage
   pp storage
   end
  if data[:source][:verified] == true
    Twitter.direct_message_create('your user id here', message )
 end
end

if data[:event] == 'favorite'
message = "@"+"#{data[:source][:screen_name]}"+" just "+ "#{data[:event]}" +"d you!"
 File.open(filename,'a') do |f1|
 storage = tt + ","+ "#{data[:event]},#{data[:source][:screen_name]},#{data[:source][:followers_count]},#{data[:source][:verified]},#{data[:target_object][:id]},#{data[:target_object][:created_at]},"
   f1.puts storage
    pp storage
   end
  if data[:source][:verified] == true
    Twitter.direct_message_create('your user id here', message )
  end
end

end

client.userstream
