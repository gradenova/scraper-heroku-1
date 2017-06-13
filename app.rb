require "sinatra"
require "mechanize"
require "./models/webscrapers"
require 'sinatra/cookies'

get "/" do
	erb :index
end


get "/search" do

	if cookies[:loggedin] == true 
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
	if cookies[:loggedin] == true 
		erb :schedule
	else
		redirect "/"
	end
end

get "/signup" do
	erb :signup
end


get "/login" do
	erb :login
end


get "/csv/hofequipment" do

	if cookies[:loggedin] == true 
		send_file('csv/hofequipment.csv', :filename => "csv/hofequipment.csv")
	else
		redirect "/"
	end

end

get "/csv/industrialsafety" do

	if cookies[:loggedin] == true 
		send_file('csv/industrialsafety.csv', :filename => "csv/industrialsafety.csv")
	else
		redirect "/"
	end

end

get "/csv/toolfetch" do

	if cookies[:loggedin] == true 
		send_file('csv/toolfetch.csv', :filename => "csv/toolfetch.csv")
	else
		redirect "/"
	end	
end

get "/csv/mixed" do

	if cookies[:loggedin] == true 
		send_file('csv/mixed.csv', :filename => "csv/mixed.csv")
	else
		redirect "/"
	end	

end
