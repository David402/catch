# Use this command to launch the server with webbrick.
webbrick: bundle exec rackup config.ru -p $PORT

# Use this command to launch the server with unicorn instead. 
# For WebRTC app, we need use this instead of default Webbrick 
# since we will keep socket open for the communication/streaming
# purpose.
#
# http://zbatery.bogomip.org/README.html
#
web: zbatery -rbundler/setup -c ./config/rainbow.rb -p $PORT