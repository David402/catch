# To take advantage of Heroku’s realtime logging, you will need to disable this buffering to have log messages sent straight to Logplex.
$stdout.sync = true

# The latest changesets to Ruby 1.9.2 no longer make the current directory . part of your LOAD_PATH
# 
# http://stackoverflow.com/questions/2900370/why-does-ruby-1-9-2-remove-from-load-path-and-whats-the-alternative
# 
require './main'

## There is no need to set directories here anymore;
## Just run the application

run Sinatra::Application
