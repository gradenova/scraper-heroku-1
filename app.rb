require "sinatra"
require "mechanize"
require "./models/webscrapers"


get "/" do
	erb :index
end


get "/search" do
	erb :search
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
	erb :schedule
end

get "/signup" do
	erb :signup
end

get "/login" do
	erb :login
end


get "/csv/hofequipment" do
	send_file('csv/hofequipment.csv', :filename => "csv/hofequipment.csv")
end

get "/csv/industrialsafety" do
	send_file('csv/industrialsafety.csv', :filename => "csv/industrialsafety.csv")
end

get "/csv/toolfetch" do
	send_file('csv/toolfetch.csv', :filename => "csv/toolfetch.csv")
end

get "/csv/mixed" do
	send_file('csv/mixed.csv', :filename => "csv/mixed.csv")
end
