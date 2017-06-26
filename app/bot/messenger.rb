require 'facebook/messenger'

include Facebook::Messenger

Facebook::Messenger::Subscriptions.subscribe(access_token: ENV["ACCESS_TOKEN"])

Bot.on :postback do |postback|
  Message.process(postback, postback.sender)

end

Bot.on :message do |message|
  Message.process(message, message.sender)
end
