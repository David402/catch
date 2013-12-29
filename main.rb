# You'll need to require these if you
# want to develop while running with ruby.
# The config/rackup.ru requires these as well
# for it's own reasons.
#
# $ ruby heroku-sinatra-app.rb
#
require 'rubygems'
require 'sinatra'

require 'json'

#require 'eventmachine'

set connections: {}

configure :production do
  # Configure stuff here you'll want to
  # only be run at Heroku at boot

  # TIP:  You can get you database information
  #       from ENV['DATABASE_URI'] (see /env route below)
end

get '/' do
  "Congradulations!
   You're running Catch on Heroku!"
end

get '/webrtc' do
	erb :webrtc
end

get '/webrtc/sender' do
	erb :webrtc_sender
end

get '/webrtc/receiver' do
	erb :webrtc_receiver
end


get '/webrtc/signal/source' do
	puts "receive event on /webrtc/signal/source"

	content_type "text/event-stream"

	stream :keep_open do |out|
		#EventMachine::PeriodicTimer.new(20) { out << "data: \n\n" } # added
		# while true do
		# 	# out << "custom: my_msg_type\n"
		# 	msg = { hello: 'world' }
		# 	out << "data: #{JSON.dump(msg)}\n\n"
		# 	sleep(3)
		# end
    	settings.connections << out
    	puts "connections count: #{settings.connections.count}" # added
    	msg = { hello: 'world'}
    	out << "data: #{JSON.dump(msg)}"
    	out.callback { puts 'closed'; settings.connections.delete(out) } # modified
  	end
end

get '/webrtc/signal/sender' do
	puts "receive event on /webrtc/signal/sender"

	content_type "text/event-stream"

	stream do |out|
    	settings.connections["1234"] = out
    	printConnectionsInfo;

    	while true do
			msg = { hello: 'world' }
			out << "data: #{JSON.dump(msg)}\n\n"
			sleep(3)
    	end

   #  	out.callback { 
			# puts 'closed'; 
			# settings.connections.delete("1234");
			# printConnectionsInfo;
   #  	}
  	end
end

get '/webrtc/signal/receiver' do
	puts "receive event on /webrtc/signal/receiver"

	content_type "text/event-stream"

	stream :keep_open do |out|
    	settings.connections["1111"] = out
    	printConnectionsInfo;

    	while true do
			msg = { hello: 'world' }
			out << "data: #{JSON.dump(msg)}\n\n"
			sleep(3)
    	end

   #  	out.callback { 
			# puts 'closed'; 
			# settings.connections.delete("1111");
			# printConnectionsInfo;
   #  	}
  	end
end

def printConnectionsInfo
	puts "connections hash size: #{settings.connections.size}"

	puts "connections sender? #{settings.connections.has_key?("1234")}"
	# settings.connections.has_key?("1234")? do
	# 	puts "connections sender count: #{settings.connections["1234"].length}"
	# end

	puts "connections receiver? #{settings.connections.has_key?("1111")}"
	# settings.connections.has_key?("1111")? do
	# 	puts "connections receiver count: #{settings.connections["1111"].length}"
	# end
end

# Transmit 'signal' to `destination`
post '/webrtc/signal/transmitter' do
	puts "receive event on /webrtc/signal/transmitter"
	puts "body: #{request.body}"

	printConnectionsInfo;

	request.body.rewind  # in case someone already read it
	json = JSON.parse(request.body.read);
	dests = json['destinations'];
	signal = json['body'];
	puts "json data #{json}"
	puts "dests: #{dests}"
	puts "signal: #{signal}"

	dests.each do |dest|
		out = settings.connections[dest];
		# out << "data: #{JSON.dump(signal)}\n\n"
		out << "data: #{signal}\n\n"
	end
	
end

get '/webrtc/signal/leave_source' do
	puts "receive event on /webrtc/signal/leave_source"
end

# You can see all your app specific information this way.
# IMPORTANT! This is a very bad thing to do for a production
# application with sensitive information

# get '/env' do
#   ENV.inspect
# end
