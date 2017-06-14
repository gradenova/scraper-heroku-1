require "sinatra"
require "mechanize"
require "./models/webscrapers"
require 'sinatra/activerecord'
require "./models/login"
require "sinatra/cookies"

get "/" do
	erb :index
end


get "/search" do

	if cookies[:loggedin] == "yes"
		erb :search
	else
		redirect "/"
	end
end

post "/search" do

	query = params[:q]
	@hof = params[:hof]
	@industry = params[:industry]
	@tool = params[:tool]

	myscraper = WebScrapers.new
	if @hof == "hofequipment"
		@hofarray = myscraper.arrayhofequipment(query)
	end

	if @industry == "industrialsafety"
		@industrialarray = myscraper.arrayindustrialsafety(query)
	end

	if @tool == "toolfetch"
		@toolfetcharray = myscraper.arraytoolfetch(query)
	end	

	erb :search
end

get "/schedule" do
	if cookies[:loggedin] == "yes" 
		erb :schedule
	else
		redirect "/"
	end
end

get "/signup" do
	erb :signup
end

post "/signup" do
	@signup = Login.new(params[:model])

	if @signup.save
		cookies[:loggedin] = "yes"
		redirect '/schedule'
	else
		redirect "/signup"
		@error = "Sorry, there was an error!"
	end

end


get "/login" do
	erb :login
end

post "/login" do

	loginform = Login.find_by(name: params[:name], password: params[:password])

	if loginform
		cookies[:loggedin] = "yes" 
		redirect "/schedule"
	else
		"no"
	end

end

get "/csv/hofequipment" do

	if cookies[:loggedin] == "yes"
		send_file('csv/hofequipment.csv', :filename => "csv/hofequipment.csv")
	else
		redirect "/"
	end

end

get "/csv/industrialsafety" do

	if cookies[:loggedin] == "yes"
		send_file('csv/industrialsafety.csv', :filename => "csv/industrialsafety.csv")
	else
		redirect "/"
	end

end

get "/csv/toolfetch" do

	if cookies[:loggedin] == "yes"
		send_file('csv/toolfetch.csv', :filename => "csv/toolfetch.csv")
	else
		redirect "/"
	end	
end

get "/csv/mixed" do

	if cookies[:loggedin] == "yes"
		send_file('csv/mixed.csv', :filename => "csv/mixed.csv")
	else
		redirect "/"
	end	

end
