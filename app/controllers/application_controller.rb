class ApplicationController < Sinatra::Base
	use Rack::Flash
	register Sinatra::ActiveRecordExtension

	configure do
		set :views, "app/views"
		set :database_file, '../../config/database.yml'
		enable :sessions
		# set :session_secret, SECRET
		set :session_secret, ENV["SECRET"]

	end

	get "/" do
		if logged_in?
			redirect "/items"
		else
			redirect "/login"
		end
	end


	helpers do
		def login(params)
			user = User.find_by(username: params[:username])

			if user && user.authenticate(params[:password])
				session[:user_id] = user.id
				flash[:message] = "Hi, #{user.username}, you're logged in!"

				redirect "/items"
			else
				flash[:message] = "Sorry, try again!"

				redirect "/login"
			end
		end

		def logged_in?
			!!current_user
		end

		def current_user
			@current_user ||= User.find(session[:user_id]) if session[:user_id]
		end

		def logout
			session.clear

			redirect "/"
		end
	end
end